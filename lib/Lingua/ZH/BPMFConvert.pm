package Lingua::ZH::BPMFConvert;
use warnings;
use strict;
use utf8;
use Encode;
use base qw/Exporter/;
our @EXPORT=qw/BPMF_to_Pinyin/;

=head1 NAME

Lingua::ZH::BPMFConvert - Rule-based conversion of BPMF (bopomofo) into Hanyu Pinyin

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This is a rule-based convertor of BPMF into Hanyu Pinyin. Unlike previous modules it does not rely on any data table, therefore it is possible to convert neophonisms (new phonetic combinations previously not existing in Mandarin) into corresponding Hanyu Pinyin.

    use utf8;
    use Lingua::ZH::BPMFConvert
    my $pinyin = BPMF_to_Pinyin("ㄓㄨㄥ");    # in Perl string; returns "zhong"

=head1 FUNCTIONS

=head2 BPMF_to_Pinyin ($bpmf);

=cut

# this makes the basic table BPMF->Pinyin
my %symbolmap=qw(ㄅ b ㄆ p ㄇ m ㄈ f ㄉ d ㄊ t ㄋ n ㄌ l ㄍ g ㄎ k ㄏ h ㄐ j ㄑ q ㄒ x ㄓ zh ㄔ ch ㄕ sh ㄖ r ㄗ z ㄘ c ㄙ s ㄧ i ㄨ u ㄩ ü ㄚ a ㄛ o ㄜ e ㄝ e ㄞ ai ㄟ ei ㄠ ao ㄡ ou ㄢ an ㄣ en ㄤ ang ㄥ eng ㄦ er ˊ 2 ˇ 3 ˋ 4 ˙ 5);
my $trickchange=join("|", keys %symbolmap);

# this makes the table BPMF->"standard layout"
my %stdmap=qw(ㄅ 1 ㄆ q ㄇ a ㄈ z ㄉ 2 ㄊ w ㄋ s ㄌ x ㄍ e ㄎ d ㄏ c ㄐ r ㄑ f ㄒ v ㄓ 5 ㄔ t ㄕ g ㄖ b ㄗ y ㄘ h ㄙ n ㄧ u ㄨ j ㄩ m ㄚ 8 ㄛ i ㄜ k ㄝ X ㄞ 9 ㄟ o ㄠ l ㄡ . ㄢ 0 ㄣ p ㄤ ; ㄥ / ㄦ - ˊ 6 ˇ 3 ˋ 4 ˙ 7);
$stdmap{"ㄝ"}=",";
my $stdchange=join("|", keys %stdmap);

my %pinyinlist;

# special replacements
my %special=qw/
    j   ji
    q   qi
    x   xi
    zh  zhi
    ch  chi
    sh  shi
    r   ri
    z   zi
    c   ci
    s   si
    ü   yu
    üan yuan
    üe  yue
    ün  yun
    w   wu
    wi  wei
    wn  wen
    y   yi
    yn  yin
    yng ying
    yu  you
/;

my %ignore=qw/
    b    1
    d    1
    eng  1
    f    1
    g    1
    h    1
    k    1
    l    1
    m    1
    n    1
    p    1
    t    1 
    nou  1
    dei  1
    yai  1
    fong 1
    shei 1
    fou  1
    fiao 1
    fo   1
    chua 1
    miu  1
/;

# these only exists in BPMF
# nou 耨鎒嗕譨羺獳            -> ?
# dei 得                     -> de 得
# yai 崖睚啀娾                -> ya
# fong 甮                    -> ?
# shei 誰                    -> shui 谁
# fou 否缶殕缹鴀罘芣紑剻       -> fou
# fiao 覅                    -> ?
# fo 佛坲                    -> fu 佛
# chua 欻                    -> ?
# miu 唒謬                   -> ?

sub BPMF_to_Pinyin {
    my $pinyin=shift;
    $pinyin =~ s/($trickchange)/$symbolmap{$1}/g;

    # ien -> in rule
    $pinyin =~ s/ien/in/g;
    
    # iou -> iu rule
    $pinyin =~ s/iou/iu/g;
    
    # uen -> un rule
    $pinyin =~ s/uen/un/g;

    # üeng -> iong rule
    $pinyin =~ s/üeng/iong/g;

    # üen -> ün rule
    $pinyin =~ s/üen/ün/g;
    
    # uei -> ui rule
    $pinyin =~ s/uei/ui/g;
        
    # ung -> ong rule
    $pinyin =~ s/ung/ong/g;
    
    # ^ong -> weng rule
    $pinyin =~ s/^ong/weng/g;
    
    # ^i -> ^y rule
    $pinyin =~ s/^i/y/g;
    
    # ^u -> ^w rule
    $pinyin =~ s/^u/w/g;
    
    # special rules
    $pinyin=$special{$pinyin} if (exists $special{$pinyin});        
    
    # ^ü -> ^w rule
    $pinyin =~ s/^ü/w/g;

    
    # ü -> u if not nü / lü
    $pinyin =~ s/ü/u/  if (!($pinyin eq "nü"));
    $pinyin =~ s/ü/u/  if (!($pinyin eq "lü"));
    
    # ü -> u  / ü -> v
    $pinyin =~ s/ü/u/;
    # $pinyin =~ s/ü/v/;
    
    
    # ignore tones
    $pinyin =~ s/2|3|4|5//g;        # voila, now we have it    
    return $pinyin;
}

=head1 AUTHOR

Lukhnos D. Liu, C<< <lukhnos@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-lingua-zh-bpmfconvert@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-ZH-BPMFConvert>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Lukhnos D. Liu, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Foo::Bar

