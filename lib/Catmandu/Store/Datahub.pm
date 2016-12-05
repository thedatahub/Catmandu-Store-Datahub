package Catmandu::Store::Datahub;

use Catmandu::Sane;

use Moo;
use Lido::XML;
use Catmandu::Store::Datahub::Bag;
use Catmandu::Store::Datahub::OAuth;
use LWP::UserAgent;


with 'Catmandu::Store';

has url           => (is => 'ro', required => 1);
has client_id     => (is => 'ro', required => 1);
has client_secret => (is => 'ro', required => 1);
has username      => (is => 'ro', required => 1);
has password      => (is => 'ro', required => 1);

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
    return LWP::UserAgent->new();
}

sub _build_access_token {
    my $self = shift;
    my $oauth = Catmandu::Store::Datahub::OAuth->new(username => $self->username, password => $self->password, client_id => $self->client_id, client_secret => $self->client_secret, url => $self->url);
    return $oauth->token();
}


1;