#!/usr/bin/python3
# coding: utf-8
# ========================================================================================
#
# Script de Didier-T
# license GPL V3 or later
#
# Description : script permettant la gestion simplifier d'une bibliothèque de conky.
#
# ========================================================================================
# -----------------------------------------------
# Ajout de bibliothèques utiles
# -----------------------------------------------
from tkinter import *
from tkinter import ttk
from tkinter.filedialog import askopenfilename
from tkinter.simpledialog import askstring, askinteger
from tkinter.colorchooser import askcolor
from tkinter.messagebox import askokcancel, showinfo, CANCEL
from subprocess import check_output, Popen
import os
from re import search, findall
from shutil import copyfile
from time import sleep
import gettext
gettext.install('ConkyControl', os.path.dirname(os.path.abspath(__file__))+'/locale')

Version='1.6'

## Données utiles ##
homedir = os.path.expanduser('~')
listfichier=[[_("Custom"), "~/.scripts/Conky/conky_liste"], ## Attention à ne pas modifier cette ligne ##
             ["Base", "~/.scripts/Conky/conky_liste1"],
             ["Extra", "~/.scripts/Conky/conky_liste2"],
             ["Extra 2", "~/.scripts/Conky/conky_liste3"],
             ["Graph", "~/.scripts/Conky/conky_liste4"],
             ["Radiotray", "~/.scripts/Conky/conky_liste5"],
             ["Bar", "~/.scripts/Conky/conky_liste6"],
             ["Flat", "~/.scripts/Conky/conky_liste7"]]
Fichier_Demarrage_Auto="~/.scripts/Conky/DemConky.sh"


## Réglage aspect fenetre ##
### Couleur menu principal
Menubg="#ECECEC" # Fond du menu
Menuabg="#F8FAF7" # Fond du menu sous la souris
Menufg="#000000" # Couleur caractères
Menuafg="#000000" # Couleur caractères sous la souris
### Menu déroulant
MenuDbg="#F8FAF7" # Fond du menu
MenuDabg="#F8FAF7" # Fond du menu sous la souris
MenuDfg="#3B3B3B" # Couleur caractères
MenuDafg="#3B3B3B" # Couleur caractères sous la souris
### Avec ou sans cadre du dessous
canvas=True # True ou False
Image="~/.scripts/Conky/conkycontrol-390.gif"
### Avec ou sans icone perso
icone=True # True ou False
Icone="~/.scripts/Conky/conky.gif"

class fonctions():
    def __init__(self):
        self.listfichier=[]
        for chemin in listfichier:
            chemin[1]=chemin[1].replace("~", homedir)
            if os.path.isfile(chemin[1]):
                self.listfichier.append(chemin)

    def initialisation(self):
        ## Récupération du temps de latence fichier de démarrage automatique ##
        fichier=Fichier_Demarrage_Auto.replace("~", homedir)
        if os.path.isfile(fichier):
            fiche = open(fichier, "r")
            lines = fiche.readlines()
            fiche.close()
            for line in lines:
                if search("sleep", line) is not None:
                    Latence=findall('-?\d+', line)[0]
                    break
        else:
            Latence=5
        ## Initialisation des bases de données et vérification des conkys lancés ##
        ### Scan Conky lancés ###
        ConkyLances=fonctions.scan()
        ### Création bases de données ###
        BasesConky=[]
        for base in self.listfichier:
            BasesConky.append([base[0],fonctions.lecture(base[1], ConkyLances)])
        return BasesConky, ConkyLances, Latence

    def scan():
        ## Scan processus extraction des conkys actifs ##
        Scan=check_output("ps ax | awk '/\ conky\ .*-c/'", shell=True).decode('utf-8').split('\n')
        index=0
        retour={}
        while index < len(Scan)-1:
            Scan[index]=Scan[index].split()
            nom=Scan[index][len(Scan[index])-1]
            ip=Scan[index][0]
            if retour.get(nom) is not None:
                Popen('kill '+retour.get(nom), shell=True)
            retour[nom]=ip
            index=index+1
        return retour

    def lecture(fichier, ConkyLances):
        ## Extraction liste conky + chemin de lancement ##
        fiche = open(fichier, "r")
        lines = fiche.readlines()
        fiche.close()
        base1 = []
        base_de_donnee = []
        index=0
        index1=0
        for line in lines:
            line=line.replace("\n", '')
            index=index+1
            if index % 2:
                base1.append(line)
            else:
                line=line.replace("~", homedir)
                base1.append(line)
                if ConkyLances.get(line) is not None:
                    base1.append(1)
                else:
                    base1.append(0)
                base_de_donnee.append(base1)
                base1=[]
        return base_de_donnee

    def ecriture(self, BasesConky):
        ## modification d'un fichier base de données ##
        fichier=self.listfichier[0][1]
        fiche = open(fichier, "w")
        for Bases in BasesConky:
            information = Bases[0]+"\n"+Bases[1].replace(homedir, "~")+"\n"
            fiche.write(information)
        fiche.close()

class MenuBar(Frame):
    ## Barre de menu déroulant ##
    def __init__(self, boss = None):
        self.MenuConky={}
        self.SuppConky={}
        self.ConkyLances={}
        self.BasesConky, self.ConkyLances, self.TempLat = fonctions.initialisation(fonctions())
        Frame.__init__(self, borderwidth = 2, bd = 1, relief = GROOVE)

        ## Menu Fermer ##
        self.fermeMenu = Menubutton(self, text = _('Menu'), relief = GROOVE, fg=Menufg, bg=Menubg, activebackground=Menuabg, activeforeground=Menuafg)

        self.fermeMenu.pack(side = LEFT)
        ### Partie déroulante ###
        self.fM = Menu(self.fermeMenu, tearoff=0, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
        self.fM.add_command(label=_('Exit'), underline = 0, command = boss.quit)
        #### Intégration du menu ####
        self.fermeMenu.configure(menu = self.fM)

        ## Menu Conky liste ##
        self.ListeMenu = Menubutton(self, text = _('Conky lists'), relief = GROOVE, fg=Menufg, bg=Menubg, activebackground=Menuabg, activeforeground=Menuafg)
        self.ListeMenu.pack(side = LEFT)
        ### Partie déroulante ###
        self.menuliste()

        ## Menu Conky gestion ##
        self.GestionMenu = Menubutton(self, text = _('Conky management'), relief = GROOVE, fg=Menufg, bg=Menubg, activebackground=Menuabg, activeforeground=Menuafg)
        self.GestionMenu.pack(side = LEFT)
        ### Partie déroulante ###
        self.menuSup()

        ## Menu Gestion démmarage ##
        self.AutoRunMenu = Menubutton(self, text = _('Autostart'), relief = GROOVE, fg=Menufg, bg=Menubg, activebackground=Menuabg, activeforeground=Menuafg)
        self.AutoRunMenu.pack(side = LEFT)
        ### Partie déroulante ###
        self.ARM = Menu(self.AutoRunMenu, tearoff=0, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
        self.ARM.add_command(label=_('Autostart delay'), underline = 0, command=self.latence)
        self.ARM.add_command(label=_('Save settings'), underline = 0, command=self.DemAuto)
        #### Intégration du menu ####
        self.AutoRunMenu.configure(menu = self.ARM)

    ## Réglage apparence conky ##
    def Reglage(self):
        self.BasesConky, self.ConkyLances, self.TempLat = fonctions.initialisation(fonctions())
        self.FenReglage=FenReglage(self, BasesConky=self.BasesConky)

    ## Réglage latence démarrage ##
    def latence(self):
        self.SavTempLat=self.TempLat
        self.TempLat=askinteger(title=_('Delay adjustment'), prompt=_('Time (in seconds)'), initialvalue=self.TempLat)
        if self.TempLat is None:
            self.TempLat=self.SavTempLat
        if self.TempLat<1:
            self.TempLat=1
        
    ## Enregistrement du fichier de démarrage automatique ##
    def DemAuto(self):
        self.ConkyLances=fonctions.scan()
        fichier=Fichier_Demarrage_Auto.replace("~", homedir)
        FichDem=["#!/bin/bash",
                "# License GPL",
                "",
                "sleep "+str(self.TempLat)+";"]
        for conky in self.ConkyLances:
            FichDem.append('sh -c "conky -c '+conky.replace(homedir, "~")+' &"')
        fiche = open(fichier, "w")
        fiche.write('\n'.join(FichDem))
        fiche.close()
        os.system("chmod ugo+x "+fichier)
        showinfo(title=_("Start-up"),message=_("File ")+Fichier_Demarrage_Auto+_(" modified"))

    ## Mise à jour des menus ##
    def MajMenu(self):
        self.GM.destroy()
        self.menuSup()
        self.lM.destroy()
        self.menuliste()

    ## Création / Mise à jour des sous menus lancement conky ##
    def menuliste(self):
        self.lM = Menu(self.ListeMenu, tearoff=0, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
        for name in self.BasesConky:
            self.listeC=Menu(self.lM, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
            self.MenuConky[name[0]]={}
            index=0
            for val in name[1]:
                self.MenuConky[name[0]][val[1]]=IntVar()
                self.listeC.add_checkbutton(label=val[0], variable=self.MenuConky[name[0]][val[1]], command=self.choixactifs)
                self.MenuConky[name[0]][val[1]].set(val[2])
                index=index+1
            self.lM.add_cascade(label=name[0], underline = 0, menu=self.listeC)
        self.lM.add_command(label=_('Killall Conky'), command=self.killall, underline=0)
        #### Intégration du menu ####
        self.ListeMenu.configure(menu = self.lM)

    ## Création / Mise à jour du sous menu suppression conky ##
    def menuSup(self):
        self.GM = Menu(self.GestionMenu, tearoff=0, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
        self.GM.add_command(label=_('Add'), command=self.ajouter, underline = 0)
        listeS=Menu(self.GM, tearoff=0, fg=MenuDfg, bg=MenuDbg, activebackground=MenuDabg, activeforeground=MenuDafg)
        for val in self.BasesConky[0][1]:
            self.SuppConky[val[1]]=IntVar()
            listeS.add_checkbutton(label=val[0], variable=self.SuppConky[val[1]], command=self.supp)
        self.GM.add_cascade(label=_('Remove'), underline = 0, menu=listeS)
        self.GM.add_command(label=_('Settings'), underline=0, command=self.Reglage)
        #### Intégration du menu ####
        self.GestionMenu.configure(menu = self.GM)

    ## Lancement ou extinction d'un conky choisi par l'utilisateur ##
    def choixactifs(self):
        self.ConkyLances=fonctions.scan()
        for name in self.MenuConky:
            for chemin in self.MenuConky[name]:
                if self.ConkyLances.get(chemin) is not None:
                    if self.MenuConky[name][chemin].get() == 0:
                        Popen('kill '+self.ConkyLances.get(chemin), shell=True)
                else:
                    if self.MenuConky[name][chemin].get() == 1:
                        Popen('conky -c '+chemin+' &', shell=True)

    ## Tuer tous les conky lancés ##
    def killall(self):
        Popen('killall conky', shell=True)
        for name in self.MenuConky:
            for chemin in self.MenuConky[name]:
                self.MenuConky[name][chemin].set(0)

    ## Suppression d'un conky au Conky Preso ##
    def supp(self):
        index=0
        while index < len(self.BasesConky[0][1]):
            if self.SuppConky.get(self.BasesConky[0][1][index][1]) is not None:
                if self.SuppConky[self.BasesConky[0][1][index][1]].get() == 1:
                    rep=askokcancel(title=_('Remove'), message=_('Are you sure you wish to remove ')+self.BasesConky[0][1][index][0]+_(' from Conky Control?'), default=CANCEL)
                    if rep==True:
                        self.BasesConky[0][1].remove(self.BasesConky[0][1][index])
                        fonctions.ecriture(fonctions(), self.BasesConky[0][1])
                        self.MajMenu()
                    else:
                        self.SuppConky[self.BasesConky[0][1][index][1]].set(0)
                    break
            index=index+1

    ## Ajout d'un conky au Conky Preso ##
    def ajouter(self):
        Chemin=askopenfilename()
        if Chemin:
            NomNouvConky=askstring(title=_('New conky'), prompt=_('New conky name'))
            if NomNouvConky is not None:
                self.BasesConky[0][1].append([NomNouvConky, Chemin, 0])
                fonctions.ecriture(fonctions(), self.BasesConky[0][1])
                self.MajMenu()

## Sous fenetre pour réglage conky ##
class FenReglage(Toplevel):
    ## Création fenetre satellite Réglage conky ##
    def __init__(self, boss, BasesConky=[], **Arguments):
        Toplevel.__init__(self, boss, **Arguments)
        self.items=[]
        self.BasesConky=BasesConky
        self.BoiteAOnglet()

    def RemplissageListechoix(self):
        for name in self.BasesConky:
            for val in name[1]:
                if val[2]==1:
                    self.liste.insert(END, val[0])
                    self.items.append(val)

    def BoiteAOnglet(self):
        Reglage = Frame(self, name='settings')
        Reglage.pack(side=TOP, fill=BOTH, expand=YES)
        ## Création listebox + ascenceur ##
        ascenseur= Scrollbar(Reglage)
        self.liste= Listbox(Reglage, yscrollcommand=ascenseur.set)
        ## Remplissage liste box + liste
        self.RemplissageListechoix()
        ## mise en place de la listebox ##
        ascenseur.config(command=self.liste.yview)
        ascenseur.pack(side=LEFT, expand=YES, fill=Y)
        self.liste.bind("<ButtonRelease-1>", self.sortie)
        self.liste.pack(side=LEFT, fill=Y)
        nb = ttk.Notebook(Reglage, name='settings')
        nb.enable_traversal()
        nb.pack(fill=BOTH, expand=Y, padx=2, pady=3)
        ## Création des onglets ##
        self.Position(nb)
#        self.Apparence(nb)  ## En attente
        ## Ajout des boutons de fonctionnement ##
        self.Test=Button(Reglage, text=_('Apply'), underline=0, width=10, command=self.Valider, state=DISABLED)
        self.Anuller=Button(Reglage, text=_('Confirm'), underline=0, width=10, command=self.destroy)
        self.Valider=Button(Reglage, text=_('Cancel'), underline=0, width=10, command=self.Anule, state=DISABLED)
        self.Anuller.pack(side=RIGHT, fill=X, expand=YES)
        self.Valider.pack(side=RIGHT, fill=X, expand=YES)
        self.Test.pack(side=RIGHT, fill=X, expand=YES)
        ## Fixer la taille de la nouvelle fenetre ##
        self.resizable(width=False, height=False)

    def Anule(self):
        copyfile(self.item[1]+".Sauv", self.item[1])
        self.Horizon.delete(0, 5)
        self.Vertical.delete(0, 5)
        self.initialisation()

    def Valider(self):
        self.gap_x=self.Horizon.get()
        self.gap_y=self.Vertical.get()
        alignmentSedMod=self.alignmentSed.replace(self.alignmentSauv, self.alignment, 1)
        gap_xSedMod=self.gap_xSed.replace(self.gap_xSauv, self.Horizon.get(), 1)
        gap_ySedMod=self.gap_ySed.replace(self.gap_ySauv, self.Vertical.get(), 1)
        Popen('sed -i".bak" "s/'+self.alignmentSed+'/'+alignmentSedMod+'/" '+self.item[1], shell=True)
        Popen('sed -i -e "s/'+self.gap_xSed+'/'+gap_xSedMod+'/" -e "s/'+self.gap_ySed+'/'+gap_ySedMod+'/" '+self.item[1], shell=True)
        self.Relance()
        self.alignmentSed=alignmentSedMod
        self.gap_xSed=gap_xSedMod
        self.gap_ySed=gap_ySedMod
        self.alignmentSauv=self.alignment
        self.gap_xSauv=self.Horizon.get()
        self.gap_ySauv=self.Vertical.get()

    def Relance(self):
        ## Redémarrage du Conky, si nécessaire ##
        sleep(1)
        ConkyLances=fonctions.scan()
        ip=ConkyLances.get(self.item[1])
        if ip is not None:
            Popen('kill '+ip, shell=True)
            Popen('conky -c '+self.item[1]+' &', shell=True)

    ## Choix fichier a éditer ##
    def sortie(self, event=None):
        index=self.liste.curselection()
        ind0=int(index[0])
        self.item=self.items[ind0]
        self.initialisation()

    def initialisation(self):
        copyfile(self.item[1], self.item[1]+".Sauv")
        fiche = open(self.item[1], "r")
        lines = fiche.readlines()
        fiche.close()
        for line in lines:
            Diese=1000
            if search("#", line) is not None:
                Diese=line.rfind("#")
            if search("gap_x", line) is not None:
                if Diese > line.rfind("gap_x"):
                    self.gap_x=findall('-?\d+', line)[0]
                    self.gap_xSed=line.replace("\n","")
            if search("gap_y", line) is not None:
                if Diese > line.rfind("gap_y"):
                    self.gap_y=findall('-?\d+', line)[0]
                    self.gap_ySed=line.replace("\n","")
            if search("alignment", line) is not None:
                if Diese > line.rfind("alignment"):
                    self.alignment=findall('-?\w+', line)[1]
                    self.alignmentSed=line.replace("\n","")
                    self.alignmentSauv=self.alignment
                    if len(self.alignment) > 2:
                        mot1, mot2=self.alignment.split("_")
                        self.alignment=mot1[0]+mot2[0]
        self.gap_xSauv=self.gap_x
        self.gap_ySauv=self.gap_y

        ## activation des options ##
        self.Test.config(state=NORMAL)
        self.Valider.config(state=NORMAL)
        self.Vertical.config(state=NORMAL)
        self.Horizon.config(state=NORMAL)
        self.EtatBouton()

        ## Réglage Décalage x & y ##
        self.Horizon.delete(0, 5)
        self.Vertical.delete(0, 5)
        self.Horizon.insert(0, self.gap_x)
        self.Vertical.insert(0, self.gap_y)

    def EtatBouton(self):
        ## Réglage état boutons ##
        if self.alignment=="tl":
            self.HG.config(state=DISABLED)
        else:
            self.HG.config(state=NORMAL)
        if self.alignment=="tm":
            self.HM.config(state=DISABLED)
        else:
            self.HM.config(state=NORMAL)
        if self.alignment=="tr":
            self.HD.config(state=DISABLED)
        else:
            self.HD.config(state=NORMAL)
        if self.alignment=="ml":
            self.MG.config(state=DISABLED)
        else:
            self.MG.config(state=NORMAL)
        if self.alignment=="mm":
            self.MM.config(state=DISABLED)
        else:
            self.MM.config(state=NORMAL)
        if self.alignment=="mr":
            self.MD.config(state=DISABLED)
        else:
            self.MD.config(state=NORMAL)
        if self.alignment=="bl":
            self.BG.config(state=DISABLED)
        else:
            self.BG.config(state=NORMAL)
        if self.alignment=="bm":
            self.BM.config(state=DISABLED)
        else:
            self.BM.config(state=NORMAL)
        if self.alignment=="br":
            self.BD.config(state=DISABLED)
        else:
            self.BD.config(state=NORMAL)


    ## Onglet position ##
    def Position(self, nb):
        frame = ttk.Frame(nb, name='position')
        frame.rowconfigure(1, weight=0)
        frame.columnconfigure(1, weight=0, uniform=1)
        nb.add(frame, text=_('Position'), underline=0, padding=2)
        ## Création Boutons postion conky ##
        frameH= Frame(frame, name="haut", relief=GROOVE, bd=5)
        self.HG=Button(frameH, text=_('Top-left'), underline=0, width=10, command= lambda: ChangePos("tl"), state=DISABLED)
        self.HM=Button(frameH, text=_('Top-middle'), underline=0, width=10, command= lambda: ChangePos("tm"), state=DISABLED)
        self.HD=Button(frameH, text=_('Top-right'), underline=0, width=10, command= lambda: ChangePos("tr"), state=DISABLED)
        self.MG=Button(frameH, text=_('Middle-left'), underline=0, width=10, command= lambda: ChangePos("ml"), state=DISABLED)
        self.MM=Button(frameH, text=_('Middle-middle'), underline=0, width=10, command= lambda: ChangePos("mm"), state=DISABLED)
        self.MD=Button(frameH, text=_('Middle-right'), underline=0, width=10, command= lambda: ChangePos("mr"), state=DISABLED)
        self.BG=Button(frameH, text=_('Bottom-left'), underline=0, width=10, command= lambda: ChangePos("bl"), state=DISABLED)
        self.BM=Button(frameH, text=_('Bottom-middle'), underline=0, width=10, command= lambda: ChangePos("bm"), state=DISABLED)
        self.BD=Button(frameH, text=_('Bottom-right'), underline=0, width=10, command= lambda: ChangePos("br"), state=DISABLED)
        self.HG.grid(row=0, column=0)
        self.HM.grid(row=0, column=1)
        self.HD.grid(row=0, column=2)
        self.MG.grid(row=1, column=0)
        self.MM.grid(row=1, column=1)
        self.MD.grid(row=1, column=2)
        self.BG.grid(row=2, column=0)
        self.BM.grid(row=2, column=1)
        self.BD.grid(row=2, column=2)
        ## Mise en place frame haut ##
        frameH.rowconfigure(1, weight=0)
        frameH.columnconfigure(1, weight=0, uniform=1)
        frameH.grid(row=0, column=0, columnspan=3, sticky=N)
        ## Frame bas ##
        frameB= Frame(frame, name="bottom", relief=GROOVE, bd=5)
        ## Determiner taille ecran ##
        haut, larg = frame.winfo_screenheight(), frame.winfo_screenwidth()
        ## Décalage horizontal ##
        self.Horizon=Spinbox(frameB, from_=-larg, to=larg, width=8, repeatdelay=300, state=DISABLED)
        self.Horizon.grid(row=0, column=1, columnspan=1, sticky=SW)
        HorizonLabel = Label(frameB, text=_("Horizontal max ")+str(larg))
        HorizonLabel.grid(row=0, column=0, columnspan=1, sticky=SW)
        ## Décalage Vertical ##
        self.Vertical=Spinbox(frameB, from_=-haut, to=haut, width=8, repeatdelay=300, state=DISABLED)
        self.Vertical.grid(row=1, column=1, columnspan=1, sticky=SW)
        VerticalLabel = Label(frameB, text=_("Vertical max ")+str(haut))
        VerticalLabel.grid(row=1, column=0, columnspan=1, sticky=SW)
        ## Mise en place frame bas ##
        frameB.rowconfigure(1, weight=0)
        frameB.columnconfigure(1, weight=0, uniform=1)
        frameB.grid(row=1, column=0, columnspan=2, sticky=SW)

        ### modification postion suite clique bouton ###
        def ChangePos(pos):
            self.alignment=pos
            self.EtatBouton()

#################################################################
    ## Onglet apparence ##
    def Apparence(self, nb):
        frame = ttk.Frame(nb, name='apparence')
        frame.rowconfigure(1, weight=1)
        frame.columnconfigure((0,1), weight=1, uniform=1)
        nb.add(frame, text='Apparence', underline=0, padding=2)
        ## Création et remplissage frame Transparence ##
        frameT= Frame(frame, name="haut", relief=GROOVE, bd=5)
        self.var = StringVar()
        FT = Radiobutton(frameT, text="False transparency", variable=self.var, value="False transparency", command=self.transparence)
        FT.pack( anchor = W )
        VT = Radiobutton(frameT, text="True transparency", variable=self.var, value="True transparency", command=self.transparence)
        VT.pack( anchor = W )
        ST = Radiobutton(frameT, text="Opaque", variable=self.var, value="Opaque", command=self.transparence)
        ST.pack( anchor = W )
        Couleur=Button(frameT, bg='#FF0000', activebackground='#FF0000')
        Couleur.pack( anchor = W )
        ## Mise en place frame Transaparence ##
        frameT.rowconfigure(1, weight=0)
        frameT.columnconfigure(1, weight=0, uniform=1)
        frameT.grid(row=0, column=0, columnspan=3, sticky=N)

    def transparence(self):
        print(self.var.get())
#################################################################

class application(Frame):
    ## Application principal ##
    def __init__(self, boss = None, **Arguments):
        Frame.__init__(self)
        self.master.title('Conky Control')
        self.master.resizable(width=False,height=False)
        mBar = MenuBar(self)
        mBar.pack()
        if canvas:
            Image1=Image.replace("~", homedir)
            self.filename = PhotoImage(file = Image1)
            self.can = Canvas(self, bg='light grey', borderwidth=2, height=390, width=480)
            self.item=self.can.create_image(0, 0, anchor=NW, image=self.filename)
            self.can.pack()
        if icone:
            Image2=Icone.replace("~", homedir)
            self.iconename = PhotoImage(file = Image2)
            self.master.call('wm', 'iconphoto', self.master, self.iconename)
        self.pack()

if __name__ == '__main__':
    print("Conky control Version "+Version)
    app = application()
    app.mainloop()
