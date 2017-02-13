# (c) Martin Wheldon
# Info: https://github.com/wheldom01/rt-extension-csvcustomfields
#
# This code is free software; you can redistribute it and/or
# modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
# License as published by the Free Software Foundation; either
# version 3 of the License, or any later version.
#
# This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU AFFERO GENERAL PUBLIC LICENSE for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.
#

use strict;
use warnings;
package RT::Extension::CSVCustomFields;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-CSVCustomFields - displays a freeform customfield as multiple
input fields.

=head1 DESCRIPTION

This extension for RT adds the ability to display freeform customfields as multiple
input form fields and combines the resulting data in a comma seperated format.


=head1 RT VERSION

Works with RT 4.4

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Adding this line:

    Plugin('RT::Extension::CSVCustomFields');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

A RT CustomField can be enabled as a CSV CustomField by adding its name to the
configuration hash as shown below:

    Set(%CSVCustomFields,
        'Books'      => [],
    );

The CustomField "Books" will utilise the hardcoded default column titles of
"Title" and "Description". However the configeration syntax allows you to
have more columns if required and to name those column titles as you see fit.

    Set(%CSVCustomFields,
        'Books'            => [             # Stick to a 2 column layout
            { 'title' => "Name" }           # Rename the first column title to "Name"
        ],
        'Newspapers'       => [             # Stick to a 2 column layout
            {},                             # Leave the first column title as the default
            { 'title' => "Desc" }           # Rename the second column title to "Desc"
        ],
        'Order'           => [              # Create a 6 column layout
            { 'title' =>  "No."},
            {},                             # Leave the second column title as the default
            { 'title' =>  "Cost"},
            { 'title' =>  "Tax"},
            { 'title' =>  "Total"},
        ],
    );

Table column layout can be modified by adding css files to local/static/css
then adding a CSSFiles configuration line to the RT_Site-Config.pm file

    Set( @CSSFiles, ('CSVcf-books.css', 'CSFcf-Order.css) );

which may contain something akin to the following css.

    table#custom-field-4 #column-0,
    table#custom-field-4 #column-2 {
        text-align: center;
        width: 75px;
    }
    table#custom-field-4 #column-1 {
        width: auto;
    }
    table#custom-field-4 #column-3 {
        text-align: center;
        width: 55px;
    }
    table#custom-field-4 #column-4 {
        text-align: center;
    }
    table#custom-field-4 #column-0 input[type=text],
    table#custom-field-4 #column-2 input[type=text] {
        text-align: center;
        width: 40px;
    }
    table#custom-field-4 #column-1 input[type=text] {
        text-align: left;
        width: 95%;
    }
    table#custom-field-4 #column-3 input[type=text] {
        text-align: center;
        width: 55px;
    }


=head1 AUTHOR

Martin Wheldon E<lt>martin.wheldon@greenhills-it.co.uk<gt>

=head1 BUGS

All bugs should be reported via email to

    Lmailto:bug-RT-Extension-CSVCustomFields@greenhills-it.co.uk>

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2017 by Martin Wheldon

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

# Add the base stylesheet to the RT paths
RT->AddStyleSheets('csvcustomfields.css')
    if $RT::StaticPath;



1;
