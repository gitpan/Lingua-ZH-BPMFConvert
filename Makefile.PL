use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::ZH::BPMFConvert',
    AUTHOR              => 'Lukhnos D. Liu <lukhnos@cpan.org>',
    VERSION_FROM        => 'lib/Lingua/ZH/BPMFConvert.pm',
    ABSTRACT_FROM       => 'lib/Lingua/ZH/BPMFConvert.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-ZH-BPMFConvert-*' },
);
