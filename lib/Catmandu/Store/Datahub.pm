package Catmandu::Store::Datahub;

use Catmandu::Sane;

use Moo;
use Lido::XML;
use LWP::UserAgent;
use Catmandu::Store::Datahub::Bag;
use Catmandu::Store::Datahub::OAuth;

use REST::Client;

with 'Catmandu::Store';

has url        => (is => 'ro', required => 1);
has oauth_code => (is => 'ro', required => 1);

has lido     => (is => 'lazy');
has client   => (is => 'lazy');

##
# TODO: error reporting 'n stuff

sub _build_lido {
    my $self = shift;
    return Lido::XML->new();
}

sub _build_client {
    my $self = shift;
    #my $oath = Catmandu::Store::Datahub::OAuth->new(code => $self->oauth_code);
    #my $client = $oauth->client;
    my $client = LWP::UserAgent->new();
    return $client;
}


1;