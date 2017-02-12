use inc::Module::Install;

RTx     'RT-Extension-CSVCustomFields';
license 'gplv2';
repository 'https://github.com/wheldom01/rt-extension-csvcustomfields';

requires_rt '4.4.0';
rt_too_new '4.6.0';

substitute(
    {
        RT_LIB_PATH  => $lib_path,
        RT_BIN_PATH  => $bin_path,
        PERL         => $ENV{PERL} || $secure_perl_path,
    },
           {
        sufix => '.in'
    },
           qw(lib/RT/Extension/CSVCustomFields/Test.pm),
);

sign;
WriteAll;
