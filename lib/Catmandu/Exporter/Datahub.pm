package Catmandu::Exporter::Datahub;

use Catmandu::Sane;
use LWP::UserAgent;
use HTTP::Request;

use Moo;
use Lido::XML;

with 'Catmandu::Exporter';

has 'lido'      => (is => 'lazy');

sub _build_lido {
    return Lido::XML->new;
}

##
# Add a single item ($data) to the datahub API
sub add {
    my ($self, $data) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->agent('Catmandu-Datahub/1.0');

    my $req = HTTP::Request->new(POST => 'https://demo2201983.mockable.io/datahub');
    $req->content_type('application/xml');
    $req->content($self->lido->to_xml($data));
    my $res = $ua->request($req);
    if ($res->is_success) {
        print $res->content;
    } else {
        print $res->status_line, "\n";
    }
}

1;