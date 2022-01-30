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
