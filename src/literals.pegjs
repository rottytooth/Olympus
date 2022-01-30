// LITERALS

Literal = StringLiteral / CharLiteral / NumberLiteral

// This is awkward, but may be the best we can do in pure regex.
// Each makes one part non-optional, where what we need is "at least one but it could be any"
NumberLiteral =
    mil:MillionsDigit DigitSeparator? thou:ThousandsDigit? DigitSeparator? hun:HundredsDigit? DigitSeparator? end:EndDigit?
{
	if (DEBUG) console.log("in NumberLiteral Millions");
	let retval = mil;
    if (thou) retval += thou;
    if (hun) retval += hun;
    if (end) retval += end;
	return { type: "IntLiteral", value: retval };
} / thou:ThousandsDigit DigitSeparator? hun:HundredsDigit? DigitSeparator? end:EndDigit?
{
	if (DEBUG) console.log("in NumberLiteral Thousands");
	let retval = thou;
    if (hun) retval += hun;
    if (end) retval += end;
	return { type: "IntLiteral", value: retval };
} / hun:HundredsDigit DigitSeparator? end:EndDigit?
{
	if (DEBUG) console.log("in NumberLiteral Hundreds");
	let retval = hun;
    if (end) retval += end;
	return { type: "IntLiteral", value: retval };
} / end:EndDigit
{
	if (DEBUG) console.log("in NumberLiteral EndDigit");
	return { type: "IntLiteral", value: end };
}

MillionsDigit = 
	end:(HundredsDigit/EndDigit) (_ / "-")? ("M"/"m") "illion"
{
	if (DEBUG) console.log("in MillionsDigit");
	return end * 1000000;
}

ThousandsDigit = 
	hun:HundredsDigit (_ "and" _ / _ / "-")? end:EndDigit? ("T"/"t") "housand"
{
	if (DEBUG) console.log("in ThousandsDigit");
	let retval = 0;
    if (end) retval += end;
    if (hun) retval += hun;
	return retval * 1000;
} / end:EndDigit (_ / "-")? ("T"/"t") "housand" 
{
	if (DEBUG) console.log("in EndDigit");
	return end * 1000;
}

HundredsDigit = 
	end:EndDigit (_ / "-")? ("H"/"h") "undred"
{
	return end * 100;
}

EndDigit = TeensDigit / tens:TensDigit (_ "and" _ / "," _ / "-" / _)? ones:OnesDigit?
{
	let retval = 0;
	if (tens) retval += tens;
	if (ones) retval += ones;
	return retval;
} / ones:OnesDigit

TensDigit = 
	"ten" { return 10; } /
	"twenty" { return 20; } /
    "thirty" { return 30; } /
    "forty" { return 40; } /
    "fifty" { return 50; } /
    "sixty" { return 60; } /
	"seventy" { return 70; } /
    "eighty" { return 80; } /
    "ninety" { return 90; }

OnesDigit = 
	"zero" { return 0; } /
	"one" { return 1; } /
    "two" { return 2; } /
    "three" { return 3; } /
    "four" { return 4; } /
    "five" { return 5; } / 
    "six" { return 6; } /
    "seven" { return 7; } /
    "eight" { return 8; } /
    "nine" { return 9; } /
    "zero" { return 0; } 

TeensDigit = 
    "eleven" { return 11; } /
    "twelve" { return 12; } /
    "thirteen" { return 13; } /
    "fourteen" { return 14; } /
    "fifteen" { return 15; } / 
    "sixteen" { return 16; } /
    "seventeen" { return 17; } /
    "eighteen" { return 18; } /
    "nineteen" { return 19; }

DigitSeparator = (", and" _ / " and" _ / "," _ / _)

StringLiteral = _? '"' val:[^"]* '"' _?
{ 
	return {
		type: 'StringLiteral',
		value: val.join("") 
    };
}

CharLiteral = _? "'" val:[^'] "'" _?
{ 
	return {
		type: 'CharLiteral',
		value: val 
	};
}

Identifier = d:[0-9a-zA-Z_]+ { return d.join(""); }
    
// end of LITERALS
