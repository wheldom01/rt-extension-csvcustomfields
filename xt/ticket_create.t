use strict;
use warnings;

use RT::Extension::CSVCustomFields::Test tests => undef;

# Load the General Queue
my $queue = RT::Test->load_or_create_queue( Name => 'General' );
ok( $queue->id, "loaded the General queue" );

my ($base, $m) = RT::Test->started_ok;

# Build Create.html link
my $CreateUrl = "/Ticket/Create.html?Queue=" . $queue->id;
my $DisplayUrl = "/Ticket/Display.html?id=1";

$m->login;

# Create a normal text customfield
my $cf = RT::Test->load_or_create_custom_field(
    Name        => 'normal',
    Type        => 'FreeformMultiple',
    Queue       => $queue->id,
    LookupType  => 'RT::Queue-RT::Ticket',
);
ok $cf && $cf->id, "Created Text customfield";

# Create the csvcustom field
my $csv_cf = RT::Test->load_or_create_custom_field(
    Name        => 'testcsv',
    Type        => 'FreeformMultiple',
    Queue       => $queue->id,
    LookupType  => 'RT::Queue-RT::Ticket',
);
ok $csv_cf && $csv_cf->id, "Created CSV customfield";

# open ticket "Create.html" page
$m->get_ok($CreateUrl, "fetched $CreateUrl");
ok $m->form_name('TicketCreate'), "found form TicketCreate";

note "Check that normal CF not formatted as CSV";
{
    my $cf_id = $cf->id;
    my $name = "Object-RT::Ticket--CustomField-$cf_id-Values";
    $m->content_contains('normal');
    my @inputs = $m->grep_inputs( {
                                     type => qr/^(textarea|hidden)$/,
                                     name => qr/^$name$/,
                                } );
    # FIXME: need to check content of form field should be empty
    is scalar @inputs, 1, 'found form field' . $name;
}

note "Check that CSV CF is formatted as CSV";
{
    my $cf_id = $csv_cf->id;
    my $name = "Object-RT::Ticket--CustomField-$cf_id-Values";

    $m->content_contains('testcsv:');
    my @inputs;
    for my $y (0..1) {
        @inputs = $m->grep_inputs( {
                                type => qr/^(textarea|hidden)$/,
                                name => qr/^$name--Row0-Col$y$/,
                                } );
        # FIXME: need to check content of form field should be empty
        is scalar @inputs, 1, "found form field $name--Row0-Col$y";
    }
}

note "Check that we can add to form TicketCreate";
{
    my $cf_id = $csv_cf->id;
    my $name = "Object-RT::Ticket--CustomField-$cf_id-Values";

    $m->submit_form_ok( {
                          form_name => 'TicketCreate',
                          fields => {
                          "$name--Row0-Col0" => 'CsvColumn0TitleText',
                          "$name--Row0-Col1" => 'CsvColumn1TitleText',
                          "$name--Row1-Col0" => 'foo',
                          "$name--Row1-Col1" => 'bar',
                           },
                      }, 'Submit with CSVCustomFields');

    $m->content_contains('CsvColumn1TitleText');
    $m->content_contains('CsvColumn2TitleText');
    $m->content_contains('foo');
    $m->content_contains('bar');

}

note "Check that the form submitted and information updated";
{
    my $cf_id = $csv_cf->id;
    my $name = "Object-RT::Ticket-1-CustomField-$cf_id-Values";

    # open ticket "Display.html" page
    $m->get_ok($DisplayUrl, "fetched $DisplayUrl");

    $m->content_contains('CsvColumn1TitleText');
    $m->content_contains('CsvColumn2TitleText');
    $m->content_contains('foo');
    $m->content_contains('bar');

}

undef $m;
done_testing;
