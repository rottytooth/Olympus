// Start
{
    const DEBUG = false; // set to true to see debug information, including matches


    // GLOBALS for ADORATION

    const GOD2REQUEST = {
        'Mnemosyne' : ['assign','var'],
    	'Athena' : ['function'],
        'Zeus' : ['function'],
        'Hades': ['destroy'],
        'Artemis': ['for'],
        'Ariadne' : ['check','assign_condition','call'],
        'Hermes': ['print','call','input'],
        'Aphrodite': ['eval'],
        'Ares': [],
    };

    const PHRASE_LENGTH = 25;

    const score_praise = (epithets, minscore, god) => {
        var sum = epithets.reduce(function (previousValue, currentValue) {
            return previousValue + Math.floor(currentValue.length / PHRASE_LENGTH) + 1;
        }, 0);
        if (sum < minscore) {
            error(`Not enough adoration for ${god}`)
        }
        return sum;
	}
}

Start = _? Opening prog:Invocation+ _? Closing?
{ 
    let program = {
        type: 'Program', 
        invocations: prog 
    };
    return program;
}
    
Opening = 	"Come, happy, deathless Gods! Hearken to my prayer!" / 
			"Come! Hear my prayer!"

Closing = "O great Gods, with all the splendor of Olympus," _ [^!]+ "!" _?

Invocation = __+ _? ad:Adoration (Supplication _?)+ c:(Request (_ "and" _)?)+ Pause
{
	// remove the _ and _
	var requestlist = c.map(function(value,index) { return value[0]; });
    
    if (requestlist.length > ad.epithets.length - ad.praise_factor) {
    	error("You ask too much of " + ad.god);
    }
    
    let requests = requestlist.map(n => n.type);
    let god = ad.god;
    
    if (DEBUG) console.log(GOD2REQUEST[god].includes(first_req));
    
    var h = GOD2REQUEST[god].filter(value => requests.includes(value));
    if (h.length < 1) {
    	error(`${god} is not the appropriate god for this request (${requests}), ${god} brings ${GOD2REQUEST[god]}`);
    }

	if (DEBUG) console.log(first_req);
    if (DEBUG) console.log(god);
    
    var cmd = {
        type: 'invocation',
        adoration: ad,
//        cmd_count: requestlist.length,
//        ept_count: ad.epithets.length,
        requests: requestlist
    };
    return cmd;
}

Supplication = "please" ","? / ("if in the past you have looked favorably upon me" 
	(_ "when I've been in need")? ", ") / (("I ask you" / "I implore you" / "I beg you") " to") / "I ask that you" / "I beg that you"
{
    if (DEBUG) console.log("in Supplication");
}

Pause = "."/";"/"?"/"!"
{
    if (DEBUG) console.log("in Pause");
}

// ADORATION

Adoration = ("O" _)? g:(Mnemosyne / Zeus / Athena / Hades / Artemis / Ariadne / Demeter / Aphrodite / Hermes / Ares) _?
{
    if (DEBUG) console.log("in Adoration");
    return g;
}

Mnemosyne = g:("Mindful" _)? "Mnemosyne," _ f:("mistress of memory" "," _ / "holder of tales old and new" "," _ / "by whom the soul with intellect is joined" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	if (g) { 
    	f = [g[0], ...f] 
    }

	const score = score_praise(f, 2, "Mnemosyne"); 

    return {
        god: "Mnemosyne",
        praise_factor: 0,
        epithets: f,
        score: score
    };
} // initializing memory, declaring variables

Zeus = ("Lord" _)? "Zeus," _ f:("who rules Olympus" "," _ / "defender of cities" "," _ /"defender of homes" "," _ / "defender of the travelers and of those far from home" "," _ / "master of storms" "," _ / "father of the gods" "," _ / "of the lightning strike" "," _ / "of the sturdy oak" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 4, "Zeus"); 

	return {
        god: "Zeus",
        praise_factor: 3,
        epithets: f,
        score: score
    };
} // Anything structural

Athena = g:("Pallas" _ / "Clear-minded" _ / "Great and good" _)? "Athena" ","? _ f:("lady of Athens" "," _ / "patron of heroes" "," _ / "of the horses" "," _ / "bestower of wisdom" "," _ / "granter of reason" "," _ / "who hears all words spoken in market and assembly" "," _ / "all in brilliant armor" "," _ / "purger of evils" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	if (g) { 
    	f = [g[0], ...f] 
    }
    
	const score = score_praise(f, 4, "Athena"); 

	return {
        god: "Athena",
        praise_factor: 1,
        epithets: f,
        score: score
    };
} // Anything structural
    
Hades = ("Lord" _)? "Hades," _ f:("magnanimous and just" "," _ /"thy realm an earthy tomb" "," _ / "remote from mortals in their fleshy bust" "," _ / "wrapped in Kharon's watery road" "," _ / "thy throne is fixed in the dismal plains" "," _ / "unknown to most beings" "," _ / "lord of the dead" "," _ / "lord of the dusky underworld" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 1, "Hades"); 

	return {
        god: "Hades",
        praise_factor: 2,
        epithets: f,
        score: score
    };
} // destroying an object, setting anything to zero or null, ending a loop

Artemis = "Artemis," _ f:("sister of the far-shooter" "," _ / "virgin who delights in arrows" "," _ / "fostered with Apollo" "," _ / "who swiftly drives her all-golden chariot through Smyrna to vine-clad Claros" "," _ / "far-shooting goddess" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 3, "Artemis"); 

	return {
        god: "Artemis",
        praise_factor: 2,
        epithets: f,
        score: score        
    };
} 

Ariadne = "Ariadne," _ f:("pure one" "," _ / "ancient one" "," _ /"mistress of the labyrinth" "," _ / "mistress of the serpent" "," _ / "wise and cunning one whose agile mind finds purchase on the frailest of notions" "," _ / "goddess who turns, and turns, and turns again until the way is clear" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 3, "Ariadne"); 

	return {
        god: "Ariadne",
        praise_factor: 2,
        epithets: f,
        score: score
    };
} // anything that produces multiplicities of paths or breaks linearity

Demeter = n:("Demeter"/"Ceres") "," _ f:("goddess who grants the gift of abundance" "," _ / "lady of the golden sword and glorious fruits" "," _ / "all-bounteous" "," _ / "friend of the farmer" "," _ / "golden-haired" "," _ / "great lady of the land" "," _ / "goddess of seed" "," _ / "nurse of all mortals" "," _ / "bearing light" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 3, "Demeter"); 

	return {
        god: "Demeter",
        name: n,
        praise_factor: 2,
        epithets: f,
        score: score
    };
} // Printing or taking input

Aphrodite = "Aphrodite," _ f:("glory of Olympus" "," _ / "golden one" "," _ / "goddess of marriage" "," _ / "born" "e"? _ "of seaform" "," _ / "born" "e"? _ "on the ocean's waves" "," _ / "your beauty by god or mortal unseen" "," _ / "your power over heart and mind unknown" "," _ / "who sees the truth within us" "," _ / "source of pursuation" "," _ / "blessed one" "," _ / "who holds us close" "," _ / "freshest of Olympus's flowers" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 4, "Aphrodite"); 

    return {
        god: "Aphrodite",
        praise_factor: 3,
        epithets: f,
        score: score
    };
}

Hermes = (("Great"/"Cyllenian") _)? n:"Hermes" "," _ f:("lord of Cyllene and Arcadia rich in flocks" "," _ / "whom Maia bare" "," _ / "son of Zeus" "," _ / "luck-bringing messenger of the deathless god" "," _ / "messenger of Olympus" "," _ / "the Slayer of Argus" "," _ / "giver of grace" "," _ / "giver of good things" "," _ )+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 2, "Hermes"); 

	return {
        god: "Hermes",
        praise_factor: 1,
        name: n,
        epithets: f,
        score: score
    };
}

Ares = ("Lord" _)? n:("Ares"/"Mars") "," _ f:("courageous one" "," _ / "well-honored in Thrace and in Scythia" "," _ / "strong of arm" "," _ / "quick of wit" "," _ / "magnanimus" "," _ / "fierce and untamed" "," _ / "whose miighty power can make the straongest walls from their foundations shake" "," _ / "defiled with gore" "," _)+
{
	f = f.map(v => v[0]); // remove "," _

	const score = score_praise(f, 3, "Ares"); 

	return {
        god: "Ares",
        praise_factor: 2,
        name: n,
        epithets: f,
        score: score
    };
}

// end of ADORATION

// REQUESTS

Request = cmd:(PartialCall / Call / Declare / DeclareInScope / AddParam / AssignCondition /Assign / Print / Return / Destroy / Eval)
{	
    if (DEBUG) console.log("in Request");
	return cmd;
}

// FIXME: Is this necessary or can be folded into Declare / DeclareInScope?
// curry
PartialCall = wh1:Where? (Establish _ "a")? _? "call" (_ "to")? _ id:Identifier params:GetParams? _? (Name/Named) _? curriedid:Identifier
{
    if (DEBUG) console.log("in PartialCall");
	return {
    	type: "call",
        id: id,
        params: params,
        loc: wh1,
        curriedid: curriedid
    };
}

// FIXME: Is this necessary or can be folded into Declare / DeclareInScope?
// call a func
Call = wh1:Where? (Establish _ "a")? _? "call" (_ "to")? _ id:Identifier params:GetParams?
{
    if (DEBUG) console.log("in Call");
	return {
    	type: "call",
        id: id,
        params: params,
        loc: wh1
    };
} / "calls" _ id:Identifier params:GetParams?
{
    if (DEBUG) console.log("in Calls");
	return {
    	type: "call",
        id: id,
        params: params
    };
}

// declare top level
Declare = Establish _ k:(Function / ForLoop / Var / If) (_ (Name/Named))? _ id:Identifier params:GetParams? FunctionBody? con:Assign?
{
    if (DEBUG) console.log("in Declare");
	return {
       ...k,
       id: id,
       params: params
    }
}

// declare within a function (same as append body)
DeclareInScope = wh1:Where Establish _ k:(ForLoop / Var / If / CallDirectObject) _? (Name/Named) _ id:Identifier params:GetParams? funcbody:FunctionBody? con:Assign?
{
    if (DEBUG) console.log("in DeclareInScope First")
	return {
       ...k,
       id: id,
       params: params, 
       loc: wh1,
       funcbody: funcbody
    }
} / Grant _ (("the" _)? "function" _ )? fun:Identifier _ k:(ForLoop / Var) _? (Name/Named) _ id:Identifier params:GetParams? funcbody:FunctionBody? con:Assign?
{
    if (DEBUG) console.log("in DeclareInScope Second");
	return {
       ...k,
       id: id,
       params: params, 
       loc: fun,
       funcbody: funcbody
    }
} / Grant _ (("the" _)? "function" _ )? fun:Identifier _ k:(If / CallDirectObject) _? id:((Name/Named) _ Identifier)? params:GetParams? funcbody:FunctionBody? con:Assign?
{
    if (DEBUG) console.log("in DeclareInScope Second");
    
    if (id && id.length > 0) {
    	id = id[2];
    }
	return {
       ...k,
       id: id,
       params: params, 
       loc: fun,
       funcbody: funcbody
    }
}

AddParam = Grant _ ("the" _)? "function" _ func:Identifier _ id:ParamName // add a parameter to existing fun
{
    if (DEBUG) console.log("in AddParam");
	return {
    	type: "add_param",
    	func: func,
    	id: id
    }
}

AssignCondition = Grant _ id:Identifier _ "a" _ "condition" param:(_ "for" _ ParamName)? _ "where" _ exp:Expression
{
    if (DEBUG) console.log("in AssignCondition");
	return {
    	type: "assign_condition",
    	exp: exp,
        param: param[3],
    	id: id
    }

}

Assign = Grant _ id:("it"/Identifier) _ ("with" / ("the"/"an"/"a") (_ ("value"/"missive")))? _ exp:Expression
{
    if (DEBUG) console.log("in Assign");
    if (id == "it") id = "<prev id>";
    
    return {
        type: "assign",
        id: id,
        exp: exp
    };
}

Print =  wh1:Where? "print" "s"? _ exp:Expression
{
    if (DEBUG) console.log("in Print");
    return {
        type: "print",
        exp: exp,
        loc: wh1
    };
}

Return =  wh1:Where? "return" "s"? _ exp:Expression
{
    if (DEBUG) console.log("in Return");
    return {
        type: "return",
        exp: exp,
        loc: wh1
    };
}

Eval = wh1:Where? "eval" "s"? _ exp:Expression
{
    if (DEBUG) console.log("in Eval");
    return {
        type: "return",
        exp: exp,
        loc: wh1
    };
}

Destroy = "collect all variables that remain, stranded in the functions of Chion or in the main sequence to live on in your netherworld" // FIXME: yet to be implemented
{   
    return {
        type: "destroy",
        exp: "all"
    };
}

// Used by AddParam for the naming of the parameter
ParamName = (("a"/"the") _)? ("parameter"/"param") (_ (Name/Named))? _ id:Identifier
{
    if (DEBUG) console.log("in ParamName");
	return id;
}


// synonyms
Grant = ("add"/"give"/"assign") _ "to"/"give"/"grant" / "place within" / "inscribe"
Establish = "create" / "establish" / "make" / "produce"
Name = ("and" _ ("name"/"call") _ "it") { if (DEBUG) console.log("in Name"); }
Named = ("named"/"called") { if (DEBUG) console.log("in Named"); }


// location of where something is added
Where = _? w:(WhereBeginning / WhereInside) _ id:Identifier ","? _?
{
    if (DEBUG) console.log("in Where");
	return {
    	"type":w,
        "name":id
    };
}

WhereBeginning = ("at the beginning of" / "at the start of" / "at the top of") { return "start" }
WhereInside = ("inside"/"within") { return "inside"; }

GetParams = _ ("that" _ "has" (_ ("a"/"the") _)? /"with" _ "the" / "with" / "for") _ ("parameter"/"param") "s"? _ params:(Identifier " and "?)+
{
    if (DEBUG) console.log("in GetParams");
	params = params.map(f => (
    	{
			type: "param_name",
        	name: f[0]        	
        }
    ));
	return params;
}

FunctionBody = _? ("that"/"to") _?  // NOTE: ADD FOR SUB-COMMANDS INSIDE A LOOP

ForLoop = ("a" _)? "loop" _ ("counting" _)? "from" _ start:(Expression) _? "to" _ end:(Expression)
{
    if (DEBUG) console.log("in ForLoop");
    return {
        type: "for",
        start: start,
        end: end
    }
}

Function = ("a" _)? "function"
{
    if (DEBUG) console.log("in Function");
    return {
        type: "function"
    }
}

Var = "a" _ "vessel" 
{
    if (DEBUG) console.log("in Var");
    return {
        type: "var"
    }
}

If = "a" _ "check"
{
    if (DEBUG) console.log("in If");
    return {
        type: "check"
    }
}

// FIXME: Shouold this be combined with Call / Partial Call above?
// NOTE: A Partial Call is a Call with its own name (?)
CallDirectObject = "a" _ "call" _ "to" _ ("function" _)? id:Identifier prams:GetParams?
{
	if (DEBUG) console.log("in CallDirectObject");
    return {
    	type: "call"
        
    }
}

// end of REQUESTS
// EXPRESSIONS

/*
	NOTE: Expressions are lists, the assumption is everything with more than one element is a list. This can cause some verbal ambiguity in cases like "the quotient of 4 and the sum of 5 and 6 and 7", which translates to [4 / (5 + 6), 7], not 4 / (5 + 6 + 7)
*/ 
Expression = _? exp:(ExpressionBlock/Comparison)  explist:( _? (", and"/"and"/",") _+ Expression)? 
{
	if (DEBUG) console.log("in Expression");
	if (explist != null) {
		explist = explist[3];
        console.log(explist);
    }
    if (explist != null) {
        console.log([exp].concat(explist));
		return [exp].concat(explist);
    } else {
    	console.log(exp);
    	return exp;
    }
}

ExpressionBlock = '(' _? exp:Expression _? ')'
{
	if (DEBUG) console.log("in ExpressionBlock");
	return {
		type: "ExpressionBlock",
		expression: exp
	};
}

Comparison = left:(ExpressionBlock/AdditiveExpression) _? op:(EqualTo/NotEqualTo/GreaterThan/LessThan/LessThanEqualTo/GreaterThanEqualTo) _? right:(ExpressionBlock/Expression)
{
	if (DEBUG) console.log("in Comparison");
	return {
		type: "Comparison",
		operator: op,
		left: left,
		right: right
	};
} / AdditiveExpression

EqualTo = ("is equal to"/ "equals") { return "=="; }
NotEqualTo = ("is not equal to"/"is differant from"/"is not") { return "!="; }
GreaterThan = ("is greater than"/"is more than") { return ">"; }
LessThan = ("is less than"/"is fewer than") { return "<"; }
LessThanEqualTo = ("is less than or equal to"/"is less than or the same as") { return "<="; }
GreaterThanEqualTo = ("is greater than or equal to"/"is more than or the same as"/"is more than or the same as") { return ">="; }


AdditiveExpression
  = left:(ExpressionBlock/MultiplicativeExpression) _? op:(AdditionOp/SubtractionOp) _? right:(ExpressionBlock/AdditiveExpression) 
{
	if (DEBUG) console.log("in AdditiveExpression");
	return {
		type: "Additive", 
		operator: op,
		left: left,
		right: right
    };
} /
  ("T"/"t") "he" _? op:(AdditionOpDirectObject/SubtractionOpDirectObject) _? "of" _+ left:(ExpressionBlock/MultiplicativeExpression) _? "and" _? right:(ExpressionBlock/AdditiveExpression)
{
	if (DEBUG) console.log("in AdditiveExpression DirectObject");
	return {
		type: "Additive", 
		operator: op,
		left: left,
		right: right
    };
} / MultiplicativeExpression
  
MultiplicativeExpression
    = left:(ExpressionBlock/UnaryExpression) _? op:(MultiplicationOp/DivisionOp/ModuloOp) _? right:(ExpressionBlock/MultiplicativeExpression) 
{ 
	if (DEBUG) console.log("in MultiplicativeExpression");
	return {
    	type: "Multiplicative", 
    	operator: op,
    	left: left,
    	right: right
    };
} /
  ("T"/"t") "he" _? op:(MultiplicationOpDirectObject/DivisionOpDirectObject/ModuloOpDirectObject) _? "of" _+ left:(ExpressionBlock/MultiplicativeExpression) _? "and" _? right:(ExpressionBlock/AdditiveExpression)    
{ 
	if (DEBUG) console.log("in MultiplicativeExpression DirectObject");
	return {
    	type: "Multiplicative", 
    	operator: op,
    	left: left,
    	right: right
    };
} / UnaryExpression

AdditionOp = "plus" { return "+"; }    
AdditionOpDirectObject = "sum" { return "+"; }
SubtractionOp = "minus" { return "-"; }
SubtractionOpDirectObject = "difference" { return "-"; }
MultiplicationOp = "times" { return "*"; }
MultiplicationOpDirectObject = "product" { return "*"; }
DivisionOp = "divided by" { return "/"; }
DivisionOpDirectObject = "quotient" { return "/"; }
ModuloOp = "modulo" { return "%"; }
ModuloOpDirectObject = "modulus" { return "%"; }

UnaryExpression = g:(Literal / VariableName)
{
	return g;
}

VariableName = ("the" _ ("variable"/"var"/"vessel"))? id:Identifier 
{ 
	if (DEBUG) console.log("in VariableName");
	return {
		type: "VariableName",
        name: id 
    };
}

// end of EXPRESSIONS

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


_ "whitespace" = [ \r\n\t]+ 

__ "newline" = [\r\n]+