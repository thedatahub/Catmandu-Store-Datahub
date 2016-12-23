package Catmandu::Store::Datahub::Bag;

use Moo;
use Scalar::Util qw(reftype);
use LWP::UserAgent;
use Catmandu::Util qw(is_string require_package);
use Time::HiRes qw(usleep);
use Catmandu::Sane;
use JSON;

with 'Catmandu::Bag';

##
# before add in ::Bag creates a _id tag, which is useful for hashes and NoSQL-dbs, but breaks our
# XML conversion. You *can* remove it in your add/update function, but that feels unclean.
# You cannot use before add here to remove the _id, as this one is added before the before add
# from ::Bag (see http://search.cpan.org/~ether/Moose-2.1806/lib/Moose/Manual/MethodModifiers.pod).
# But around is called last. So we use it here.
around add => sub {
    my $orig = shift;
    my ($self, $data) = @_;
    return $self->$orig($data);
};

around update => sub {
    my $orig = shift;
    my ($self, $id, $data) = @_;
    return $self->$orig($data);
};

sub generator {
    my $self = shift;
}


##
# Return a record identified by $id
sub get {
    my ($self, $id) = @_;
    my $url = sprintf('%s/api/v1/data/%s', $self->store->url, $id);
    
    my $response = $self->store->client->get($url, Authorization => sprintf('Bearer %s', $self->store->access_token));
    if ($response->is_success) {
        return decode_json($response->decoded_content);
    } elsif ($response->code == 401) {
        my $error = decode_json($response->decoded_content);
        if ($error->{'error_description'} eq 'The access token provided has expired.') {
            $self->store->set_access_token();
            return $self->get($id);
        }
    } else {
        Catmandu::HTTPError->throw({
                code             => $response->code,
                message          => $response->status_line,
                url              => $response->request->uri,
                method           => $response->request->method,
                request_headers  => [],
                request_body     => $response->request->decoded_content,
                response_headers => [],
                response_body    => $response->decoded_content,
            });
        return undef;
    }
}

##
# Create a new record
sub add {
    my ($self, $data) = @_;
    my $url;

    my $lido_data = $self->store->lido->to_xml($data);
    
    my $token = $self->store->access_token;
    my $response;

    if ($self->in_datahub($data->{'lidoRecID'}->[0]->{'_'})) {
        my $id = $data->{'lidoRecID'}->[0]->{'_'};
        $url = sprintf('%s/api/v1/data/%s', $self->store->url, $id);
        $response = $self->store->client->put($url, Content_Type => 'application/lido+xml', Authorization => sprintf('Bearer %s', $token), Content => $lido_data);
    } else {
        $url = sprintf('%s/api/v1/data.lidoxml', $self->store->url);
        $response = $self->store->client->post($url, Content_Type => 'application/lido+xml', Authorization => sprintf('Bearer %s', $token), Content => $lido_data);
    }
    if ($response->is_success) {
        return $response->decoded_content;
    } elsif ($response->code == 401) {
        my $error = decode_json($response->decoded_content);
        if ($error->{'error_description'} eq 'The access token provided has expired.') {
            $self->store->set_access_token();
            return $self->add($data);
        }
    } else {
        Catmandu::HTTPError->throw({
                code             => $response->code,
                message          => $response->status_line,
                url              => $response->request->uri,
                method           => $response->request->method,
                request_headers  => [],
                request_body     => $response->request->decoded_content,
                response_headers => [],
                response_body    => $response->decoded_content,
            });
        return undef;
    }
}

##
# Update a record
sub update {
    my ($self, $id, $data) = @_;
    my $url = sprintf('%s/api/v1/data/%s', $self->store->url, $id);

    my $lido_data = $self->store->lido->to_xml($data);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->put($url, Content_Type => 'application/lido+xml', Authorization => sprintf('Bearer %s', $token), Content => $lido_data);
    if ($response->is_success) {
        return $response->decoded_content;
    } elsif ($response->code == 401) {
        my $error = decode_json($response->decoded_content);
        if ($error->{'error_description'} eq 'The access token provided has expired.') {
            $self->store->set_access_token();
            return $self->update($id, $data);
        }
    } else {
        Catmandu::HTTPError->throw({
                code             => $response->code,
                message          => $response->status_line,
                url              => $response->request->uri,
                method           => $response->request->method,
                request_headers  => [],
                request_body     => $response->request->decoded_content,
                response_headers => [],
                response_body    => $response->decoded_content,
            });
        return undef;
    }
}

##
# Delete a record
sub delete {
    my ($self, $id) = @_;
    my $url = sprintf('%s/api/v1/data/%s', $self->store->url, $id);
    
    my $token = $self->store->access_token;
    my $response = $self->store->client->delete($url, Authorization => sprintf('Bearer %s', $token));
    if ($response->is_success) {
        return $response->decoded_content;
    } elsif ($response->code == 401) {
        my $error = decode_json($response->decoded_content);
        if ($error->{'error_description'} eq 'The access token provided has expired.') {
            $self->store->set_access_token();
            return $self->delete($id);
        }
    } else {
        Catmandu::HTTPError->throw({
                code             => $response->code,
                message          => $response->status_line,
                url              => $response->request->uri,
                method           => $response->request->method,
                request_headers  => [],
                request_body     => $response->request->decoded_content,
                response_headers => [],
                response_body    => $response->decoded_content,
            });
        return undef;
    }
}

sub delete_all {}

##
# Check whether an item as identified by $id is already in the datahub.
# @param $id
# @return 1 (yes) / 0 (no)
sub in_datahub {
    my ($self, $id) = @_;
    my $token = $self->store->access_token;
    my $url = sprintf('%s/api/v1/data/%s', $self->store->url, $id);
    my $res = $self->store->client->get($url);
    if ($res->is_success) {
        return 1;
    } else {
        return 0;
    }
}

1;