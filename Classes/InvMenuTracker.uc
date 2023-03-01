/**
 * InvMenuTracker
 *
 * Used to keep track if a player has a menu open or not
 * More like a hack.. I know! :(
 *
 * Author:      Sinnerg (kfmods.com)
 * Modified by: Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFModsPerkReplacement1012
 */
class InvMenuTracker extends Inventory;

replication {
    reliable if (role < ROLE_Authority)
        ModifyPerk;
}

exec function ModifyPerk(KFHumanPawn pawn, class<KFVeterancyTypes> veterancy) {
    local KFPlayerReplicationInfo kfpri;

    if (role == ROLE_Authority) {
        kfpri = KFPlayerReplicationInfo(pawn.controller.PlayerReplicationInfo);
        kfpri.ClientVeteranSkill = veterancy;
        kfpri.ClientVeteranSkillLevel = GetMut().PerkStartLevel;
        pawn.VeterancyChanged(); // BUGFIX :P
        kfpri.ClientVeteranSkill.static.AddDefaultInventory(kfpri, pawn);
    }
}


private function MutPerkReplacement GetMut() {
    local MutPerkReplacement MPR;

    forEach allObjects(class'MutPerkReplacement', MPR)  break;

    if (MPR == none) {
        warn("MutPerkReplacement not found in memory!!!");
    }

    return MPR;
}