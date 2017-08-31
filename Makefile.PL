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

use inc::Module::Install;

RTx     'RT-Extension-CSVCustomFields';
license 'gplv2';
repository 'https://github.com/wheldom01/rt-extension-csvcustomfields';
include     'Module::AutoInstall';

requires 'Text::CSV' => 0;

requires_rt '4.4.0';
rt_too_new '4.6.0';

use Config;


my ($lp) = ($INC{'RT.pm'} =~ /^(.*)[\\\/]/);
my $lib_path = join( ' ', "$RT::LocalPath/lib", $lp );
my $secure_perl_path = $Config{perlpath};
if ($^O ne 'VMS') {
    $secure_perl_path .= $Config{_exe}
        unless $secure_perl_path =~ m/$Config{_exe}$/i;
}

substitute(
    {
        RT_LIB_PATH  => $lib_path,
        PERL         => $ENV{PERL} || $secure_perl_path,
    },
    {
        sufix => '.in'
    },
    qw(lib/RT/Extension/CSVCustomFields/Test.pm),
);

auto_install();
sign;
WriteAll;
