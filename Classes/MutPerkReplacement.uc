/**
 * Author:      Sinnerg (@ kfmods.com)
 * Modified by: Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFModsPerkReplacement1012
 */
class MutPerkReplacement extends Mutator
    config(KFModsPerkReplacement);

//! Perk Replacement Mutator
//!
//! Small update by arramus for mutator level selection (17th of February, 2010)
//! Thanks for the great mutator Sinnerg (arramus)
//!
//! Gives the player a menu where he can select the specialization
//! Being: Medic, Commando, Sharpshooter, Support, Berserker, Firebug, Demolitions

var config int PerkStartLevel;
var config bool bAllowRepickAfterDeath;

replication {
    reliable if (role == ROLE_Authority)
        PerkStartLevel;
}

simulated function PostNetBeginPlay() {
    SetTimer(1.0, true);
}

static function FillPlayInfo(PlayInfo PlayInfo) {
    super.FillPlayInfo(PlayInfo);

    PlayInfo.AddSetting(
        "Perk Replacement",
        "PerkStartLevel",
        "Fixed Perk Level",
        0,
        0,
        "Text",
        "1;1:6"
    );

    PlayInfo.AddSetting(
        "Perk Replacement",
        "bAllowRepickAfterDeath",
        "Allow repick after death?",
        1,
        0,
        "Check",
        ,,,
        false
    );
}

static event string GetDescriptionText(string PropName) {
    switch (PropName) {
        case "PerkStartLevel":          return "Fixed Perk Level";
        case "bAllowRepickAfterDeath":  return "Allow repick after death?";
    }

    return super.GetDescriptionText(PropName);
}

simulated function Timer() {
    local KFHumanPawn kfhp;
    local KFPlayerController kfpc;

    foreach DynamicActors(class'KFHumanPawn', kfhp) {
        if (kfhp == none || kfhp.health <= 0)   continue;

        kfpc = KFPlayerController(kfhp.Controller);
        if (kfpc == none)   continue;

        if (kfhp.FindInventoryType(class'InvMenuTracker') != none)  continue;

        if (!bAllowRepickAfterDeath) {
            // If change per round is disabled, we need to check if the player already selected a perk
            if (KFPlayerReplicationInfo(kfpc.PlayerReplicationInfo).ClientVeteranSkill != none) {
                AddTracker(kfhp);
                continue;
            }
        }

        AddTracker(kfhp);
        kfpc.ClientOpenMenu(string(class'GUISelectPerk'));
    }
}

final private simulated function AddTracker(KFHumanPawn pawn) {
    local InvMenuTracker tracker;

    tracker = pawn.spawn(class'InvMenuTracker', pawn);
    tracker.GiveTo(pawn);
}

defaultproperties {
    GroupName="KF-PerkReplacement1011"
    FriendlyName="Perk Selector 1012 (Replacement)"
    Description="Allows players to select a perk on maps where wave never changes."

    bAddToServerPackages=true

    // defaults in case someone forgets the config
    PerkStartLevel=1
    bAllowRepickAfterDeath=false
}