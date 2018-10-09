# GCDP_analysis
analysis files for GCDP

Fichiers s :
Colonnes 1, 2, et 3: x, y, z en unités de 100 kpc.
Colonnes 4, 5,et 6: vx, vy, vy en unités de 207.4 km/s
Colonnes 7 et 8: m_p et Ms0_p - masse totale mtot de la particule en unités de 10*2 Msun (les deux valeurs devraient être identiques).
Colonnes 9-17: masses m_He, m_C, m_N, m_O, m_Ne, m_Mg, m_Si, m_Fe, et masse totale en métaux m_Z, en masses solaires.
colonne 18: zg_p (Z)
Colonne 19: temps ts où la particule étoiles s'est formée (unités de 4.71e+08 ans)
Colonnes 20 et 21: id et flagfd - labels pour identifier les particules.
Colonne 22: t_n -t_s - age de la particule depuis sa formation.
Colonne 23: rho_p
Colonne 24: longueur d,adoucissement.
Colonne 25: rhos_p
Colonne 26: u_p
Colonne 27: rp
Colonne 28: vph
Colonne 29: vr
Colonne 30: thetap

Fichiers g:

Colonnes 1-3: x, y, z (centrés sur le CM; 100 kpc)
Colonnes 4-6: vx, vy, vz, ( 207.4 km/s)
Colonne 7: Masse totale de la particule (10**12 Msun) 
Colonne 8: densité du gaz
Colonne 9: énergie spécifique interne.
Colonne 10-18: masses m_He, m_C, m_N, m_O, m_Ne, m_Mg, m_Si, m_Fe, et masse totale en métaux m_Z, en masses solaires.
Colonnes 19 et 20: Labels id_p et flagfd_p.
Colonne 21: longueur d'adoucissement.
Colonne 22: poids moléculaire moyen
colonne 23: densité d'atomes d'hydrogène (1/cm**3)
Colonne 24; Température (K).
Colonne 25: rp
Colonne 26: Divergence vitesse
colonne 27 : p_p
Colonne 28 : cs (vitesse du son ?)
Colonne 29 : dt (pas de temps?)
colonne 30 : hvisgdt (viscosité artificille ?)
Colonne 31 : vph
Colonne 32 : vr
Colonne 33: rp3d
Colonne 34: as_p
Colonne 35: vr3d
Colonne 36 : peffp (pression effective?)
Colonne 37 : ts_p
Colonne 38 : alpvir
Colonne 39 : theta p
Colonne 40 : flagc 
Colonne 41: nnb

Fichiers d :

Colonnes 1-3: x, y, z centrés 
Colonnes 4-6: vx, vy, vz 
Colonne 7: masse
Colonne 8: pn
Colonne 9: distance au centre en kpc
Colonne 10: vph
Colonne 11: vr
Colonne 12: rp
Colonne 13: densité
Colonne 14: longueur d'adou. h


-----------------Z_X.out----------------------
code source: Z_X.f

À l'intérieur d'un rayon donnée, comment change avec le temps la masse d'étoiles, de gaz et de métaux ? Avec détail sur les procesus qui font varier cette masse.

1 : temps
2, 3 : nobre de particules s et g dans la région
4-9 : pour H [masse totale, movein, moveout, SF, SN, newH]
10-15 : pour O [masse totale, movein, moveout, SF, SN, newO]
16 : O/H
17-22 : pour Fe [masse totale, movein, moveout, SF, SN, newFe]
23: Fe/H
24-29 : gas total [masse total, movein, moveout, SF, SN, delta g)
30 : masse totale étoiles


où Z_f= 1 kpc,  Z_g = 15 kpc,  Z_h = 1kpc sur z, et z_o = entre 5 et 15 kpc


----------------------------radial.out-------------------------
code source: radial.f
Pour chaque temps, sort l'étude radial en bins du gaz, les étoiles et la force de la barre.

1 : temps
2, 3, 4 : numéro du bin, rayon central du bin et épaisseur du bun
6,5 : Nombre de particules de gaz dans le bin et cummulé du centre jusqu'au bin
7,8 :  Nombre de particules étoile dans le bin etcummulé du centre jusqu'au bin
9-10 : masse de gas et densité de surface du gaz dans le bin (densité stupide -> m/v)
11-12 : masse stellaire et densité de surface stellaire dans le bin
13-15 : force de la barre cummulé rendu au bin pour le gas, étoile, total

---------------------------str.out---------------------------------------
code source : radial.f 

sort la force maximale de la barre au cours de la simulation

1: temps
2, 3 : force de la barre en étoile et le rayon ou cette force est maximale
4, 5 : force de la barre en gaz et le momen ou elle est maximale.
6, 7 : force totale de la barre et le moment ou elle est maximale.


-------------------profiles.out---------------------------------
code source : profiles.f

sort pour chaque t le profil dans des bins de plusieurs valeurs. Essentiellement la même hose que bar_str.out, mais écrit différement et avec plus de métaux. Il serait aisé de rajoutr les métaux à bar_str.out en cas de besoin. 

format bizarre : 
t
suivi de 
1,2,3 : # bin, # particules de gas dans le bin, rayon central du bin
4,5 : masse de gaz total, densité de surface du gaz 
6-15 : masse de Hm He, C, N, O, Ne, Mg, Si, Fe, Z (Mg - Mh - MHe)
16-17 : OH, FeH

suivi du prochain t, puis le reste. 


--------------- sfr_profile.out -------------------------
code : sfr_profile.f

profil dans des bins de formation stellaire

1: temps
2,3: distance du bin et son épaisseur
4: masse de gas dans le bin
5: masse détoiles qui étaient du gaz lors du step présédent dans le bin
6: SFR (4/dt qui est fixe en fait)
7 : SSFR (SFR/ massse de gaz dans le bin, marche pas tant ben !)
8: le numéro du bin


------------------------sfr_map.out ---------------------------
code : sfr_profile.f

Liste de tout les évènements de formation stellaire de la galaxie.

1,2,3: position x,y,z de l'évènement
4 : distance radiale sqrt(x²+y²)
5 : temps auquel cela est arrivé
6 : masse de la particule (suposé être une constante ?)


x, y, z, r, t, ms(i)
