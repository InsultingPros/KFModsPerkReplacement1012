/**
 * Author:      Shtoyan
 * Home repo:   https://github.com/InsultingPros/KFModsPerkReplacement1012
 */
class GUISelectPerk extends FloatingWindow;

var localized string SelectPerk, RandomPerk;

var() array< class<KFVeterancyTypes> > VeterancyClasses;
var() automated GUIListBox PerkList;
var() automated GUIButton btn_SelectPerk, btn_RandomPerk;

function InitComponent(GUIController MyController, GUIComponent MyOwner) {
    super.InitComponent(MyController, MyOwner);
    Fillclasses();
}

function Fillclasses() {
    local int i;

    PerkList.List.Clear();

    for (i = 0; i < VeterancyClasses.length; i += 1) {
        if (VeterancyClasses[i] == none) {
            continue;
        }

        PerkList.List.Add(
            VeterancyClasses[i].default.VeterancyName,
            VeterancyClasses[i],
            VeterancyClasses[i].default.VeterancyName
        );
    }
}

event Closed(GUIComponent Sender, bool bCancelled) {
    local KFPlayerReplicationInfo kfpri;
    local PlayerController pc;
    local InvMenuTracker tracker;

    super.Closed(Sender, bCancelled);

    pc = PlayerOwner();
    kfpri = KFPlayerReplicationInfo(pc.pawn.PlayerReplicationInfo);

    if (kfpri != none && kfpri.ClientVeteranSkill == none) {
        tracker = GetTrackerInventory(pc.pawn);

        if (tracker != none) {
            tracker.Destroy();
        }
    }
}

function bool SelectPerkClass(GUIComponent sender) {
    local PlayerController pc;
    local InvMenuTracker tracker;

    pc = PlayerOwner();
    tracker = GetTrackerInventory(pc.pawn);
    if (tracker == none) {
        controller.CloseMenu(false);
        return true;
    }

    tracker.ModifyPerk(KFHumanPawn(pc.Pawn), class<KFVeterancyTypes>(PerkList.List.GetObject()));
    tracker.Destroy();
    controller.CloseMenu(false);
    return true;
}

function bool RandomPerkClass(GUIComponent sender) {
    local PlayerController pc;
    local InvMenuTracker tracker;

    pc = PlayerOwner();
    tracker = GetTrackerInventory(pc.pawn);
    if (tracker == none) {
        controller.CloseMenu(false);
        return true;
    }

    tracker.ModifyPerk(KFHumanPawn(pc.Pawn), VeterancyClasses[Rand(VeterancyClasses.length)]);
    tracker.Destroy();
    controller.CloseMenu(false);
    return true;
}

private final function InvMenuTracker GetTrackerInventory(pawn pawn) {
    local Inventory result;

    if (pawn == none || !pawn.IsA('KFHumanPawn')) {
        return none;
    }

    result = pawn.FindInventoryType(class'InvMenuTracker');
    if (result != none) {
        return InvMenuTracker(result);
    } else {
        return none;
    }
}

defaultproperties {
    WindowName="Perk Selection Menu"
    bAllowedAsLast=true
    WinTop=0.250000
    WinLeft=0.250000
    WinWidth=0.400000
    WinHeight=0.400000

    DefaultTop=0.250000
    DefaultLeft=0.250000
    DefaultWidth=0.400000
    DefaultHeight=0.400000

    SelectPerk="Select class"
    RandomPerk="Random class"
    VeterancyClasses(0)=class'KFMod.KFVetFieldMedic'
    VeterancyClasses(1)=class'KFMod.KFVetSupportSpec'
    VeterancyClasses(2)=class'KFMod.KFVetSharpshooter'
    VeterancyClasses(3)=class'KFMod.KFVetCommando'
    VeterancyClasses(4)=class'KFMod.KFVetBerserker'
    VeterancyClasses(5)=class'KFMod.KFVetFirebug'
    VeterancyClasses(6)=class'KFMod.KFVetDemolitions'

    Begin Object class=GUIListBox Name=classesList
        StyleName="ServerBrowserGrid"
        Hint="These are classes where you can chose from."
        FontScale=FNS_Medium
        WinTop=0.155000
        WinLeft=0.250000
        WinWidth=0.500000
        WinHeight=0.600000
        OnCreateComponent=classesList.InternalOnCreateComponent
    End Object
    PerkList=classesList

    Begin Object class=GUIButton Name=classSelectButton
        Caption="Select class"
        WinTop=0.800000
        WinLeft=0.500000
        WinWidth=0.300000
        WinHeight=0.110000
        OnClick=SelectPerkClass
        OnKeyEvent=classSelectButton.InternalOnKeyEvent
    End Object
    btn_SelectPerk=classSelectButton

    Begin Object class=GUIButton Name=SelectRandomclassBtn
        Caption="Random class"
        WinTop=0.800000
        WinLeft=0.200000
        WinWidth=0.300000
        WinHeight=0.110000
        OnClick=RandomPerkClass
        OnKeyEvent=classSelectButton.InternalOnKeyEvent
    End Object
    btn_RandomPerk=SelectRandomclassBtn
}