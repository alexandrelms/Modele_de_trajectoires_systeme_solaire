
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                      Initialisation du systeme solaire                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

% All values are in SI units.
% RGB color vectors are on a normalized 0-1 scale.
% Body dimensions are scaled for visualization purposes. 
% Scaling has no impact on model dynamics.

% Scaling
SunScaling = 0.5e2;
TerrestrialPlanetScaling = 1.2e3;

%temps de simulation de 26 mois sur notre modele
%10*365*24*60*60 temps de simulation normal 10 ans
%commence le 1er janvier 2016

%Spaceship
SP.M = 100e3; %100 tonnes
SP.R = 6.05e6*TerrestrialPlanetScaling;
SP.RGB = [1 1 1];

% Sun
Sun.M = 1.99e30;
Sun.R = 6.96e8*SunScaling;
Sun.RGB = [1 0.5 0];
Sun.Px = 5.5850e+08; 
Sun.Py = 5.5850e+08;
Sun.Pz = 5.5850e+08;
Sun.Vx = -1.4663;
Sun.Vy = 11.1238;
Sun.Vz = 4.8370;


% Earth
Earth.M = 5.97e24;
Earth.R = 6.05e6*TerrestrialPlanetScaling;
Earth.RGB = [0.3 0.6 0.8];
Earth.Px = -1.1506e+09; 
Earth.Py = -1.3910e+11;
Earth.Pz = -6.0330e+10;
Earth.Vx = 2.9288e+04;
Earth.Vy = -398.5759;
Earth.Vz = -172.5873;

% Mars
Mars.M = 6.42e23;
Mars.R = 3.39e6*TerrestrialPlanetScaling;
Mars.RGB = [0.6 0.2 0.4];
Mars.Px = -4.8883e+10; 
Mars.Py = -1.9686e+11;
Mars.Pz = -8.8994e+10;
Mars.Vx = 2.4533e+04;
Mars.Vy = -2.7622e+03;
Mars.Vz = -1.9295e+03;


sim('SIMU_systeme_solaire');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    Meta modele - OPTIMISATION TRAJECTOIRE                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('début sim')


%% Paramètres optimisation par algorithme génétique
nbMembre = 15;
nbGeneration =50;
r=1660000 + 6378e3; %rayon satellites


limiteTemps = 450;
deltaVlimite= 17000;
rayonMarsmin = 250000 + 3300000;



%% Initialisation de la population
for i = 1:1:nbMembre
    population(i).teta = 2*3.14*rand;
    population(i).phi = 3.14 * rand ;
    
    %jour et temps
    population(i).temps = randi([1 300]);

    population(i).finesse = 0;
    
    population(i).Uteta=deltaVlimite + 1;
    population(i).Uphi=deltaVlimite+1;
    
    while sqrt(population(i).Uteta*population(i).Uteta + population(i).Uphi*population(i).Uphi)>deltaVlimite
        population(i).Uteta=deltaVlimite*(2*rand-1);
        population(i).Uphi=deltaVlimite*(2*rand-1);
    end
    
    population(i).deltaV=sqrt(population(i).Uteta*population(i).Uteta + population(i).Uphi*population(i).Uphi);
    population(i).Distance_VM=0;
    population(i).temps_trajet=0;
    
end
%% Processus de la selection de la meilleure orbite

for j = 1:1:nbGeneration
    
    disp('Generation')
    disp(j)
    
    for i = 1:1:nbMembre
        
        % Conditions Initiales Satellite
        
        %conversion sphérique cartesien
        
        %SPACESHIP
        %position
        SP.Px = Px_terre(population(i).temps,1) + r*sin(population(i).teta)*cos(population(i).phi); 
        SP.Py = Py_terre(population(i).temps,1) + r*sin(population(i).teta)*sin(population(i).phi);
        SP.Pz = Pz_terre(population(i).temps,1) + r*cos(population(i).teta);
        %vitesse
        SP.Vx = Vx_terre(population(i).temps,1) + population(i).Uteta*cos(population(i).teta)*cos(population(i).phi)- population(i).Uphi*sin(population(i).phi);
        SP.Vy = Vy_terre(population(i).temps,1) + population(i).Uteta*cos(population(i).teta)*sin(population(i).phi)+population(i).Uphi*cos(population(i).phi);
        SP.Vz = Vz_terre(population(i).temps,1) - population(i).Uteta*sin(population(i).teta);
        
         % Sun
        Sun.Px = Px_sun(population(i).temps,1); 
        Sun.Py = Py_sun(population(i).temps,1);
        Sun.Pz = Pz_sun(population(i).temps,1);
        Sun.Vx = Vx_sun(population(i).temps,1);
        Sun.Vy = Vy_sun(population(i).temps,1);
        Sun.Vz = Vz_sun(population(i).temps,1);

        % Earth
        Earth.Px = Px_terre(population(i).temps,1); 
        Earth.Py = Py_terre(population(i).temps,1);
        Earth.Pz = Pz_terre(population(i).temps,1);
        Earth.Vx = Vx_terre(population(i).temps,1);
        Earth.Vy = Vy_terre(population(i).temps,1);
        Earth.Vz = Vz_terre(population(i).temps,1);
        
        % Mars
        Mars.Px = Px_mars(population(i).temps,1); 
        Mars.Py = Py_mars(population(i).temps,1);
        Mars.Pz = Pz_mars(population(i).temps,1);
        Mars.Vx = Vx_mars(population(i).temps,1);
        Mars.Vy = Vy_mars(population(i).temps,1);
        Mars.Vz = Vz_mars(population(i).temps,1);

        
        %% Simulation
        
        sim('SIMU_trajectoire_vaisseau');
        [population(i).Distance_VM, index] = min(Distance_vaisseau_mars);
        population(i).temps_trajet = temps(index);
        
       
        %% Calcul de la finesse
        
        if  population(i).Distance_VM > rayonMarsmin && population(i).deltaV < deltaVlimite && population(i).temps_trajet > 5200000 && min(Distance_vaisseau_sun) > 5e8 && max(Distance_vaisseau_sun)< 1.5e12
            
            diffDistance = population(i).Distance_VM - rayonMarsmin;
            %tempsDistance = population(i).temps;
            
            population(i).finesse = 10000000/diffDistance; %on cherche a trouver la distance minimum pour mars
            
        else
            population(i).finesse = 0; % Si la simulation ne respecte pas les critères limites, elle a alors une finesse de 0
        end
        
    end
    %% Selection de la meilleure orbite de cette génération
    [meilleureFinesse, indexMeilleureOrbite] = max([population.finesse]);
    meilleureOrbite = population(indexMeilleureOrbite);
    disp(meilleureOrbite)
    
    %% Création du tableau des finesses
    finesse(1,j) = meilleureFinesse;
    
    %% Création des futures orbites
    % On fait des variations à partir de la meilleure orbite de la
    % génération précédente
    
    population(1) = meilleureOrbite;
    for i = 2:1:nbMembre-1
        
            population(i).teta = meilleureOrbite.teta + (rand*2-1)*0.1*2*3.14;  %variation 30% de l'ancienne solution
        
            population(i).phi = meilleureOrbite.phi + (rand*2-1)*0.1*3.14;
            
            if population(i).temps > limiteTemps
                population(i).temps = meilleureOrbite.temps + abs(round(300*(rand*2-1)*0.1));
            end
            
            population(i).Uteta = deltaVlimite + 1;
            population(i).Uphi = deltaVlimite + 1;
            
            while sqrt(population(i).Uteta*population(i).Uteta + population(i).Uphi*population(i).Uphi) > deltaVlimite
               
                population(i).Uteta= meilleureOrbite.Uteta + (rand*2-1)*0.1*deltaVlimite ;
            
                population(i).Uphi= meilleureOrbite.Uphi + (rand*2-1)*0.1*deltaVlimite ;
                
            end    
            
            population(i).delatV= sqrt(population(i).Uteta*population(i).Uteta + population(i).Uphi*population(i).Uphi);
            
             
    end
    
end
%% Affichage de la meilleure orbite
disp(meilleureOrbite)

%% Visualisation sur un tracé

        %position %r sin teta cos phi
        %[meilleureOrbite.teta,PHI,R] = cart2sph(X,Y,Z)
        
        SP.Px = Px_terre(meilleureOrbite.temps,1) + r*sin(meilleureOrbite.teta)*cos(meilleureOrbite.phi); 
        SP.Py = Py_terre(meilleureOrbite.temps,1) + r*sin(meilleureOrbite.teta)*sin(meilleureOrbite.phi);
        SP.Pz = Pz_terre(meilleureOrbite.temps,1) + r*cos(meilleureOrbite.teta);
        
        %vitesse
        SP.Vx = Vx_terre(meilleureOrbite.temps,1) + meilleureOrbite.Uteta*cos(meilleureOrbite.teta)*cos(meilleureOrbite.phi)- meilleureOrbite.Uphi*sin(meilleureOrbite.phi);
        SP.Vy = Vy_terre(meilleureOrbite.temps,1) + meilleureOrbite.Uteta*cos(meilleureOrbite.teta)*sin(meilleureOrbite.phi)+meilleureOrbite.Uphi*cos(meilleureOrbite.phi);
        SP.Vz = Vz_terre(meilleureOrbite.temps,1) - meilleureOrbite.Uteta*sin(meilleureOrbite.teta);

        % Sun
        Sun.Px = Px_sun(meilleureOrbite.temps,1); 
        Sun.Py = Py_sun(meilleureOrbite.temps,1);
        Sun.Pz = Pz_sun(meilleureOrbite.temps,1);
        Sun.Vx = Vx_sun(meilleureOrbite.temps,1);
        Sun.Vy = Vy_sun(meilleureOrbite.temps,1);
        Sun.Vz = Vz_sun(meilleureOrbite.temps,1);

        % Earth
        Earth.Px = Px_terre(meilleureOrbite.temps,1); 
        Earth.Py = Py_terre(meilleureOrbite.temps,1);
        Earth.Pz = Pz_terre(meilleureOrbite.temps,1);
        Earth.Vx = Vx_terre(meilleureOrbite.temps,1);
        Earth.Vy = Vy_terre(meilleureOrbite.temps,1);
        Earth.Vz = Vz_terre(meilleureOrbite.temps,1);
        
            % Mars
        Mars.Px = Px_mars(meilleureOrbite.temps,1); 
        Mars.Py = Py_mars(meilleureOrbite.temps,1);
        Mars.Pz = Pz_mars(meilleureOrbite.temps,1);
        Mars.Vx = Vx_mars(meilleureOrbite.temps,1);
        Mars.Vy = Vy_mars(meilleureOrbite.temps,1);
        Mars.Vz = Vz_mars(meilleureOrbite.temps,1);
        

sim('SIMU_trajectoire_vaisseau');
 
disp('fin sim')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Sauvegarde et exportation de la trajectoire                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exportation = 1;

if exportation == 1
    
    if input('do you want to save (y/n)?\n','s') == "y"
    
        file_name = input('numero de la trajectoire ?\n', 's');
    
        save(file_name, 'meilleureOrbite');
    end
end



