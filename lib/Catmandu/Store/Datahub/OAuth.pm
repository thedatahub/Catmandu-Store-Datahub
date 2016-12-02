package Catmandu::Store::Datahub::OAuth;

use LWP::UserAgent;
use JSON;
use Moo;

has username => (is => 'ro', required => 1);
has password => (is => 'ro', required => 1);

has client_id     => (is => 'ro', required => 1);
has client_secret => (is => 'ro', required => 1);

has ua => (is => 'lazy');


sub _build_ua {
    my $self = shift;
    return LWP::UserAgent->new();
}

sub token {
    my $self = shift;
    # Replace this with something better as soon as we figure out how we can get rid of the password
    return $self->get_token_u_p();
}

sub get_token_u_p {
    my ($self) = @_;
    my $auth_url = 'http://datahub.app/oauth/v2/token?grant_type=password&username=%s&password=%s&client_id=%s&client_secret=%s';
    my $response = $self->ua->get(sprintf($auth_url, $self->username, $self->password, $self->client_id, $self->client_secret));
    if ($response->is_success) {
        my $token_raw = $response->decoded_content;
        my $token_parsed = decode_json($token_raw);
        return $token_parsed->{'access_token'};
    } else {
        print($response->status_line."\n");
        print($response->decoded_content."\n");
        return undef;
    }
}



1;