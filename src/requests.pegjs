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
	return {
        ...k,
        id: id,
        params: params, 
        loc: wh1,
        funcbody: funcbody,
        debug: "DeclareInScope First"
    }
} / Grant _ (("the" _)? "function" _ )? fun:Identifier _ k:(ForLoop / Var) _? (Name/Named) _ id:Identifier params:GetParams? funcbody:FunctionBody? con:Assign?
{
	return {
        ...k,
        id: id,
        params: params, 
        loc: fun,
        funcbody: funcbody,
        debug: "DeclareInScope Second"
    }
} / Grant _ (("the" _)? "function" _ )? fun:Identifier _ k:(If / CallDirectObject) _? funcbody:FunctionBody? con:Assign?
{
    if (DEBUG) console.log("in DeclareInScope Third");
    
	return {
        ...k,
        loc: fun,
        funcbody: funcbody,
        debug: "DeclareInScope Third"
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
CallDirectObject = "a" _ "call" _ "to" _ ("function" _)? id:Identifier params:GetParams?
{
	if (DEBUG) console.log("in CallDirectObject");
    return {
    	type: "call",
        id: id,
        params: params
    }
}

// end of REQUESTS