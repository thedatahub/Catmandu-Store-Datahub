package Catmandu::Store::Datahub;

use Catmandu::Sane;

use Moo;
use Lido::XML;
use Catmandu::Store::Datahub::Bag;
use Catmandu::Store::Datahub::OAuth;
use LWP::UserAgent;

use REST::Client;

with 'Catmandu::Store';

has url           => (is => 'ro', required => 1);
has client_id     => (is => 'ro', required => 1);
has client_secret => (is => 'ro', required => 1);
has username      => (is => 'ro', required => 1);
has password      => (is => 'ro', required => 1);
#has oauth_token   => (is => 'ro', required => 1);

has lido     => (is => 'lazy');
has client   => (is => 'lazy');
has access_token => (is => 'lazy');

##
# TODO: error reporting 'n stuff

sub _build_lido {
    my $self = shift;
    return Lido::XML->new();
}

sub _build_client {
    my $self = shift;
#    OAuth::Lite2::Client::UsernameAndPassword->new(
#        id => $self->client_id,
#        secret => $self->client_secret,
#        access_token_uri => 'http://datahub.app/oauth/v2/token?grant_type=password'
#    );
    return LWP::UserAgent->new();
}

sub _build_access_token {
    my $self = shift;
#    my $access_token = $self->client->get_access_token(
#        username => 'admin',
#        password => 'admin'
#    );
    #if (!defined($access_token)) {
    #    print($self->client->errstr."\n");
    #    return undef;
    #}
    #return $access_token;
    my $oauth = Catmandu::Store::Datahub::OAuth->new(username => $self->username, password => $self->password, client_id => $self->client_id, client_secret => $self->client_secret);
    return $oauth->token();
}


1;