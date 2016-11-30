package Catmandu::Store::Datahub::Bag;

use Moo;

with 'Catmandu::Bag';


sub generator {
    my ($self) = @_;
    # Get all id's
    return {
        name => $self->name,
    }
}

##
# Return a record identified by $id
sub get {
    my ($self, $id) = @_;
    $self->store->client->GET($self->store->url.'/'.$id);
    if ($self->store->client->responseCode() eq '200') {
        return $self->store->client->responseContent();
    } else {
        return undef;
    }
}

sub add {
    my ($self, $data) = @_;
    if (exists($data->{'_id'})) {
        delete($data->{'_id'});
    }
    $self->store->client->POST($self->store->url, $self->store->lido->to_xml($data), {'Content-type' => 'application/xml'});
    if ($self->store->client->responseCode() eq '200') {
        return $self->store->client->responseContent();
    } else {
        return undef;
    }
}

sub update {
    my ($self, $id, $data) = @_;
    if (exists($data->{'_id'})) {
        delete($data->{'_id'});
    }
    $self->store->client->PUT($self->store->url.'/'.$id, $self->store->lido->to_xml($data), {'Content-type' => 'application/xml'});
    if ($self->store->client->responseCode() eq '200') {
        return $self->store->client->responseContent();
    } else {
        return undef;
    }
}

sub delete {
    my ($self, $id) = @_;
    $self->store->client->DELETE($self->store->url.'/'.$id);
    if ($self->store->client->responseCode() eq '200') {
        return $self->store->client->responseContent();
    } else {
        return undef;
    }
}

sub delete_all {}

1;