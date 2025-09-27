function aa = calculAccelerationAngulaire(posA, ar, va, Forces, pcm, MI)
    MF = calculMomentForce(posA, ar, Forces, pcm);
    MC = MI * va;
    aa = MI \ (MF + cross(MC, va));
end

function MF = calculMomentForce(posA, ar, Forces, pcm)
    R_y = [cos(ar), 0, sin(ar); 0, 1, 0; -sin(ar), 0, cos(ar)];
    
    # TODO Créer constantes
    pos_md_local = R_y * [5 - 3.68/2; 1.345 + 0.724; 1.345 + 0.25];
    pos_mg_local = R_y * [5 - 3.68/2; -(1.345 + 0.724); 1.345 + 0.25];
    pos_p_local  = R_y * [10.54; 0; 0];

    pos_md_global = posA + pos_md_local;
    pos_mg_global = posA + pos_mg_local;
    pos_p_global  = posA + pos_p_local;

    force_md = R_y * [Forces(1); 0; 0];
    force_mg = R_y * [Forces(2); 0; 0];
    force_p  = [0; 0; Forces(3)];

    MF_md = cross(pos_md_global  - pcm, force_md);
    MF_mg = cross(pos_mg_global - pcm, force_mg);
    MF_p  = cross(pos_p_global - pcm, force_p);

    MF = MF_md + MF_mg + MF_p;
end