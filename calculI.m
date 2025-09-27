% Initialisation
PosA = [randi([0 1]), randi([0 1]), randi([0 1])]';
ar = randi([0 1]);
va = [randi([0 1]), randi([0 1]), randi([0 1])]';
Forces = [randi([0 1]), randi([0 1]), randi([0 1])];
posCm = [randi([0 1]), randi([0 1]), randi([0 1])]';

matriceRotation = rand(3,3);


function T = calculT(d, rc)
    dc = d - rc;
    T = [dc(2)^2 + dc(3)^2, -dc(1)*dc(2), -dc(1)*dc(3);
         -dc(1)*dc(2), dc(1)^2 + dc(3)^2, -dc(2)*dc(3);
         -dc(1)*dc(3), -dc(2)*dc(3), dc(1)^2 + dc(2)^2];
end

function I = calculICabinePilotage_0(posCm)
    masse = 1700; % kg
    rayon = 1.345; % m
    hauteur = 3.82; % m

    I_local = [((12*rayon^2 + 3*hauteur^2))/80, 0, 0;
               0, ((12*rayon^2 + 3*hauteur^2))/80, 0;
               0, 0, (3*rayon^2)/10];

    matriceRotation_1 = [1, 0, 0;
                         0, cos(pi/2), -sin(pi/2);
                         0, sin(pi/2), cos(pi/2)];

    I_global_0 = matriceRotation_1 * I_local * matriceRotation_1';

    T = calculT(posCm, [23.905, 0, 1.595]');

    I = I_global_0 + T * masse;
end

function I = calculIFuselage_0(posCm)
    masse = 15100; % kg
    rayon = 1.345; % m

    I_local = [(masse/4)*rayon^2 + (masse/12)*rayon^2, 0, 0;
               0, (masse/4)*rayon^2 + (masse/12)*rayon^2, 0;
               0, 0, (masse/2)*rayon^2];

    matriceRotation_1 = [1, 0, 0;
                         0, cos(pi/2), -sin(pi/2);
                         0, sin(pi/2), cos(pi/2)];

    I_global_0 = matriceRotation_1 * I_local * matriceRotation_1';

    T = calculT(posCm, [11.175, 0, 1.595]');

    I = I_global_0 + T * masse;
end

function I = calculIAile_0(aileGauche, posCm)
    masse = 3250; % kg
    epaisseur = 0.25; % m
    longueur = 10.6; % m
    largeur = 1.14; % m

    I_local = [(masse/12)*(longueur^2 + epaisseur^2), 0, 0;
               0, (masse/12)*(largeur^2 + epaisseur^2), 0;
               0, 0, (masse/12)*(longueur^2 + largeur^2)];

    I_global_0 = I_local;

    if aileGauche
        yPos = 6.645;
    else
        yPos = -6.645;
    end

    T = calculT(posCm, [10.54, yPos, 0.125]');

    I = I_global_0 + T * masse;
end

function I = calculIMoteur_0(moteurGauche, posCm)
    masse = 1700; % kg
    rayon = 0.724; % m

    I_local = [(masse/4)*rayon^2 + (masse/12)*rayon^2, 0, 0;
               0, (masse/4)*rayon^2 + (masse/12)*rayon^2, 0;
               0, 0, (masse/2)*rayon^2];

    matriceRotation_1 = [1, 0, 0;
                         0, cos(pi/2), -sin(pi/2);
                         0, sin(pi/2), cos(pi/2)];

    I_global_0 = matriceRotation_1 * I_local * matriceRotation_1';

    if moteurGauche
        yPos = 2.069;
    else
        yPos = -2.069;
    end

    T = calculT(posCm, [5, yPos, 1.595]');

    I = I_global_0 + T * masse;
end

function I = calculIAileron_0(posCm)
    masse = 500; % kg
    epaisseur = 0.07; % m
    hauteur = 2.1; % m
    largeur = 1.28; % m

    I_local = [(masse/12)*(hauteur^2 + epaisseur^2), 0, 0;
               0, (masse/12)*(largeur^2 + epaisseur^2), 0;
               0, 0, (masse/12)*(hauteur^2 + largeur^2)];

    I_global_0 = I_local;

    T = calculT(posCm, [0.64, 0, 2.94]');

    I = I_global_0 + T * masse;
end

function I = calculI(posCm, matriceRotation)
    I_global_0 = calculICabinePilotage_0(posCm) + ...
                 calculIFuselage_0(posCm) + ...
                 calculIAile_0(true, posCm) + ...
                 calculIAile_0(false, posCm) + ...
                 calculIMoteur_0(true, posCm) + ...
                 calculIMoteur_0(false, posCm) + ...
                 calculIAileron_0(posCm);

    I = matriceRotation * I_global_0 * matriceRotation';
end


I_result = calculI(posCm, matriceRotation);
disp(I_result);