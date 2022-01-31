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
