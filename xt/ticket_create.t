use strict;
use warnings;

use RT::Extension::CSVCustomFields::Test tests => undef;

# Load the General Queue
my $queue = RT::Test->load_or_create_queue( Name => 'General' );
ok( $queue->id, "loaded the General queue" );

my ($base, $m) = RT::Test->started_ok;

# Build Create.html link
my $CreateUrl = "/Ticket/Create.html?Queue=" . $queue->id;

$m->login;

# open ticket "Create.html" page
# FIXME: need to find out why this breaks
$m->get_ok($CreateUrl, "fetched $CreateUrl");
ok $m->form_name('TicketCreate'), "found form TicketCreate";

undef $m;
done_testing;

1;

