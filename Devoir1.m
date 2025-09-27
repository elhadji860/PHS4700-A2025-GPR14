function [pcm, MI, aa] = Devoir1(posA, ar, va, Forces)
    # TODO À supprimer et remplacer par le vrai calcul
    pcm = [0; 0; 0];
    MI = [1, 0, 0; 0, 1, 0; 0, 0, 1];

    aa = calculAccelerationAngulaire(posA, ar, va, Forces, pcm, MI);
end
