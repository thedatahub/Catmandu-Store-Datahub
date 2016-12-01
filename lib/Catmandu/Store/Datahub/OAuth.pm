package Catmandu::Store::Datahub::OAuth;

use LWP::Authen::OAuth2;

sub new {
    my $class = shift;
    my ($code) = @_;
    my $self = {
        'oauth' => LWP::Authen::OAuth2->new(
                    client_id => "",
                    client_secret => "",
                    service_provider => "",
                    redirect_uri => "",
                    save_tokens => \&save_tokens,
                    save_token_args => [$dbh],
                    token_string => $token_string
                )
    };
    $self->{'oauth'}->request_tokens(code => $code);
    my $token_string = $self->{'oauth'}->token_string;
    $self->{'client'} = $self->{'oauth'};
    bless $self, $class;
    return $self;
}



1;