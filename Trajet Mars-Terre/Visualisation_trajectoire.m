

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               Simultation trajectoire spécifique                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clc

trajectoire = input('nom de la trajectoire ?\n', 's');

load(trajectoire);

load("Positions et vitesses initiales.mat");

disp(meilleureOrbite);


%% initialisation

% Scaling
SunScaling = 0.5e2;
TerrestrialPlanetScaling = 1.2e3;

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

%Venus
Venus.M = 4.87e24;
Venus.R = 6.05e6*TerrestrialPlanetScaling;
Venus.RGB = [1 0.9 0];
Venus.Px = -1.5041e+10; 
Venus.Py = 9.7080e+10;
Venus.Pz = 4.4635e+10;
Venus.Vx = -3.4770e+04;
Venus.Vy = -5.5933e+03;
Venus.Vz = -316.8994;


%also

r=1660000 + 6378e3; %rayon satellites

limiteTemps = 500;
deltaVlimite= 17000;
rayonMarsmin = 250000 + 3300000;



%% Visualisation de la trajectoire

        
        SP.Px = Px_mars(meilleureOrbite.temps,1) + r*sin(meilleureOrbite.teta)*cos(meilleureOrbite.phi); 
        SP.Py = Py_mars(meilleureOrbite.temps,1) + r*sin(meilleureOrbite.teta)*sin(meilleureOrbite.phi);
        SP.Pz = Pz_mars(meilleureOrbite.temps,1) + r*cos(meilleureOrbite.teta);
        
        %vitesse
        SP.Vx = Vx_mars(meilleureOrbite.temps,1) + meilleureOrbite.Uteta*cos(meilleureOrbite.teta)*cos(meilleureOrbite.phi)- meilleureOrbite.Uphi*sin(meilleureOrbite.phi);
        SP.Vy = Vy_mars(meilleureOrbite.temps,1) + meilleureOrbite.Uteta*cos(meilleureOrbite.teta)*sin(meilleureOrbite.phi)+meilleureOrbite.Uphi*cos(meilleureOrbite.phi);
        SP.Vz = Vz_mars(meilleureOrbite.temps,1) - meilleureOrbite.Uteta*sin(meilleureOrbite.teta);

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
