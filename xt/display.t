use strict;
use warnings;

use RT::Extension::CSVCustomFields::Test tests => undef;

# Load the General Queue
my $queue = RT::Test->load_or_create_queue( Name => 'General' );
ok( $queue->id, "loaded the General queue" );

my ($base, $m) = RT::Test->started_ok;

$m->login;

my $ticket = RT::Test->create_ticket(
    Queue   => $queue->id,
    Subject => 'a test ticket',
);
ok $ticket && $ticket->id, "Created ticket";

# Build Display.html link
my $DisplayUrl = "/Ticket/Display.html?id=" . $ticket->id;

# Create a normal text customfield
my $cf = RT::Test->load_or_create_custom_field(
    Name        => 'normal',
    Type        => 'Text',
    Queue       => $queue->id,
    LookupType  => 'RT::Queue-RT::Ticket',
);
ok $cf && $cf->id, "Created Text customfield";

# open ticket "Basics" page
$m->get_ok($DisplayUrl, "Fetched $DisplayUrl");
$m->content_contains('normal');
$m->content_lacks('Wibble');
$m->content_lacks('Wobble');

# FIXME: only added to tidy output till warning is removed from callback
$m->warning_like(qr/Callback activated/);

# Create the csvcustom field
my $csv_cf = RT::Test->load_or_create_custom_field(
    Name        => 'testcsv',
    Type        => 'Text',
    Queue       => $queue->id,
    LookupType  => 'RT::Queue-RT::Ticket',
);
ok $csv_cf && $csv_cf->id, "Created CSV customfield";

# open ticket "Basics" page
$m->get_ok($DisplayUrl, "Fetched $DisplayUrl");
$m->content_contains('testcsv:');
$m->content_contains('Wibble');
$m->content_contains('Wobble');

# FIXME: only added to tidy output till warning is removed from callback
$m->warning_like(qr/Callback activated/);

undef $m;
done_testing;

1;

