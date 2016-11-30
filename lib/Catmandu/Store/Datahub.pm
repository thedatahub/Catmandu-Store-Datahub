package Catmandu::Store::Datahub;

use Catmandu::Sane;

use Moo;
use Lido::XML;
use Catmandu::Store::Datahub::Bag;

use REST::Client;

with 'Catmandu::Store';

has url      => (is => 'ro', required => 1);
has username => (is => 'ro', required => 1);
has password => (is => 'ro', required => 1);

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
    my $client = REST::Client->new();
    return $client;
}




1;