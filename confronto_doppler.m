%lettura output VHDL (cambiare il numero dopo doppler per specificare il
%valore di doppler che si vuole analizzare)
coseno ='doppler10cosine.txt';
seno ='doppler10sine.txt';
%quantizzatore utilizzato da Matlab per trasformare stringhe da file in
%numeri su 16 bit
q16_1=quantizer([16 15]);
%apro i file con path specificato prima
fid_coseno = fopen(coseno);
fid_seno = fopen(seno);
%inizializzo indice e leggo le prime linee da file
i=0;                            
tline_seno = fgetl(fid_seno);
tline_coseno = fgetl(fid_coseno);
%fintanto che ho linee nel file
while ischar(tline_seno)
     %incremento l'indice
     i=i+1;              
     %leggo il valore di seno
     n_seno(i)=bin2num(q16_1,tline_seno);
     %leggo il valore di coseno
     n_coseno(i)=bin2num(q16_1,tline_coseno);
     %passo alla prosima linea nel file
     tline_seno = fgetl(fid_seno);
     tline_coseno = fgetl(fid_coseno);	
end
%chiudo i file
fclose(fid_seno);
fclose(fid_coseno);

%generazione valori matlab
n=20460;            % Numero di campioni da generare
fs=20460000;        % Frequenza di campionamento
dt=1/fs;            % Passo Temporale
T_P=0.001;          % Lunghezza del codice primario 
t_fast=(0:dt:dt*(n-1));  % Asse temporale
t_off=-T_P/2;       % Offset temporale per rampa di rimozione Doppler

dopplers= -3250:625:3250;       % Set di possibili Doppler
%Seleziono il valore su cui voglio fare analisi
selected_doppler=10;
myDoppler=dopplers(selected_doppler);

% Generazione dati
drr=exp(-1i*2*pi*myDoppler*(t_fast+t_off));

%Plot Errori
figure(1);
plot(1:length(drr),20*log10(abs(real(drr)-n_coseno)));
title('Errore Parte Reale');
figure(2)
plot(1:length(drr),20*log10(abs(imag(drr)-n_seno)));
title('Errore Parte Immaginaria');

%Considerazioni
%doppler 1 3 9 11 valori abbastanza simili
%doppler 2 8 10 errore tende a salire
%doppler 4 errore quasi 0 (è una cosa buona?)
%doppler 5 6 7 ottimo