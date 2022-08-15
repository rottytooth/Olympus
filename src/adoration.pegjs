// ADORATION

Adoration = ("O" _)? g:(Mnemosyne / Zeus / Athena / Hades / Artemis / Ariadne / Demeter / Aphrodite / Hermes / Ares) _?
{
    if (DEBUG) console.log("in Adoration");
    return g;
}

Mnemosyne = g:("Mindful" _)? "Mnemosyne," _ f:("mistress of memory" "," _ / "holder of tales old and new" "," _ / "by whom the soul with intellect is joined" "," _ / "daughter of " ("Uranus"/"Ouranos"/"Gaia"/"Earth") "," _ / "of the beautiful hair" "," _ / "with eyes ever wakeful" "," _ / "who discovered the power of reason" "," _)+
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

Zeus = ("Lord" _)? "Zeus," _ f:("who rules Olympus" "," _ / "defender of cities" "," _ /"defender of homes" "," _ / "defender of the travelers and of those far from home" "," _ / "master of storms" "," _ / "father of the gods" "," _ / "of the lightning strike" "," _ / "of the sturdy oak" "," _ / "cloud-gathering" "," _ )+
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

Athena = g:("Pallas" _ / "Clear-minded" _ / "Great and good" _)? "Athena" ","? _ f:("lady of Athens" "," _ / "patron of heroes" "," _ / "of the horses" "," _ / "bestower of wisdom" "," _ / "granter of reason" "," _ / "who hears all words spoken in market and assembly" "," _ / "all in brilliant armor" "," _ / "purger of evils" "," _ / "who saves the people as they go out to war and come back" "," _)+
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

Demeter = n:("Demeter"/"Ceres") "," _ f:("goddess who grants the gift of abundance" "," _ / "lady of the golden sword and glorious fruits" "," _ / "all-bounteous" "," _ / "friend of the farmer" "," _ / "golden-haired" "," _ / "great lady of the land" "," _ / "goddess of seed" "," _ / "nurse of all mortals" "," _ / "bearing light" "," _ / "rich-haired" _ / "lady of the golden sword and glorious fruits" "," _ / "marvellous, radiant flower" "," _ )+
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

Aphrodite = "Aphrodite," _ f:("glory of Olympus" "," _ / "golden one" "," _ / "goddess of marriage" "," _ / "born" "e"? _ "of seaform" "," _ / "born" "e"? _ "on the ocean's waves" "," _ / "your beauty by god or mortal unseen" "," _ / "your power over heart and mind unknown" "," _ / "who sees the truth within us" "," _ / "source of pursuation" "," _ / "blessed one" "," _ / "who holds us close" "," _ / "freshest of Olympus's flowers" "," _ / "queen of well-built Salamis and sea-girt Cyprus" "," _ / "unbending of heart" "," / "savio" "u"? "r of cities" "," _)+
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
