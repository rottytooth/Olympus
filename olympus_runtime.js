const fs = require('fs');
const { registerTask } = require('grunt');

const build_function = (inv) => {
    // first req should be the function declaration
    // if (inv.requests[0].type !== 'function') {
    //     throw("invalid build_function() call");
    // }
    retstr = "";

    if (inv.requests[0].params)
        paramstr = inv.requests[0].params.map(n => n.name).join(",");

    retstr += `const ${inv.requests[0].id} = (${paramstr}) => {\n`;

    for(let i = 1; i < inv.requests.length; i++) {
        retstr += build_command(inv.requests[i])
    }

    retstr += "}\n";

    return retstr;
}

const build_expression = (exp) => {
    if (exp.constructor !== Array) {
        switch(exp.type) {
            case "VariableName":
                return exp.name;
            case "StringLiteral":
                return '"' + escape(exp.value) + '"';
            case "Comparison":
                return "(" + build_expression(exp.left) + " " + exp.operator + " " + build_expression(exp.right) + ")";
        }
    }
    let retset = [];
    exp.forEach(e => {
        retset.push(build_expression(e));
    });
    return retset;
}

const build_print = (req) => {
    let loc = req.loc; // in some cases, this gets written to a particular function
    let retstr = "";

    [].concat(req.exp).forEach(e => {
        retstr += `console.log(${build_expression(e)});\n`
    });
    return retstr;
}

const build_function_call = (req) => {
    let loc = req.loc; // in some cases, this gets written to a particular function
    let retstr = `${req.id}(`;

    retstr += req.params.map(e => e.name).join(",");

    retstr += ");\n"
    return retstr;
}

const build_command = (req) => {
    let retstr = "";
    switch(req.type) {
        case "print":
            return build_print(req);
        case "call":
            return build_function_call(req);
    }
    return retstr;
}

fs.readFile('./sample_code/99bottles.json', 'utf8', (err, data) => {

    source = "";

    if (err) {
        console.log(`Error reading file from disk: ${err}`);
    } else {

        // parse JSON string to JSON object
        const c = JSON.parse(data);

        c.invocations.forEach(inv => {
            // a set of connected requests

            var prev_id = ""; // assigned when we know the name of the id created or assigned by name and afterword called it

            // first requests
            if (['function','check'].includes(inv.requests[0].type)) {
                source += build_function(inv);
            } else {
                inv.requests.forEach(r => {
                    switch(r.type) {
                        case "assign_condition":
                            source += `if (${build_expression(r.exp)}) {\n`;
                            source += `\t${r.id}(${r.param});\n`;
                            source += "}\n";
                            break;
                        case "var":
                            source += `let ${r.id};\n`;
                            prev_id = r.id;
                            break;
                        case "assign":
                            varname = r.id;
                            if (varname === '<prev id>')
                                varname = prev_id;
                            source += `${varname} = ${build_expression(r.exp)};\n`;
                            break;
                    }
                });
//                console.log(source);
            }

            // inv.requests.forEach(req => {
            //     console.log(`${req.type}`)
            // });
        });

        console.log(source);
        fs.writeFile("sample_code/99bottles.js", source, function (err) {
            if (err) return console.log(err);
          });
    }

});
