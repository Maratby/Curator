return {
    ---Packs select a random mod to pull from instead of you choosing
    RarityLimiter = true,

    ---Add the Mod ID of any mod you wish to be blacklisted from to this list
    ---Some mods are internally blacklisted because they are incompatible with the code (BetmmaJokers)
    blacklist = {
        "Tsunami", ---Tsunami only adds Fusion Jokers and should be blacklisted for balance reasons. You can enable it if you want to.
        "FusionJokers", --- also only adds fusion jokers, but is less volatile than tsunami
        "joker_evolution", ---only adds evolved jokers, less volatile than fusionjokers
        "",
        "",
    }

}
