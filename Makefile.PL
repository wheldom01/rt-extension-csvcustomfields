use inc::Module::Install;

RTx     'RT-Extension-CSVCustomFields';
license 'gplv2';
repository 'https://github.com/bestpractical/rt-extension-csvcustomfields';

requires_rt '4.0.0';
rt_too_new '4.4.0';

sign;
WriteAll;
