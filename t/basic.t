#!perl -T

use utf8;
use Test::More tests => 1;

use Lingua::ZH::BPMFConvert;
is(BPMF_to_Pinyin("ㄓㄨㄥ"), "zhong");
