#!/bin/bash
# Reel lunes 2026-11-09 v4 (Victor 2026-11-02: lenguaje científico, sin mitos): "¿Querés bajar de peso rápido? ❌" — musculación, funcional (especialidad) y HIIT: solo lo que ofrece el gimnasio.
# Tomas del gym (PC de Victor: Videos Gym\_catalogo_claude\lun911\clips): c1 9455 0-2.25, c2 9456 1.5-4.2, c3 9494 4.5-7.5, c4 9493 3.0-4.1, c5 9441 1.5-4.5, c6 9494 8.0-10.85
# Imágenes IA hiperrealistas: fuentes/ia-lun911 (GEMINI gemini-3-pro-image-preview 2K 9:16) → llevar etiqueta de IA en Instagram.
set -e
W=${1:?carpeta de trabajo}; SRC=${2:?carpeta con c1..c6.mp4}; cd "$W"
F=/mnt/project-files/instagram/fuentes; IA=$F/ia-lun911
M=/mnt/project-files/instagram/musica/alexgrohl-motivation-epic-rock.mp3
LOGO=/mnt/project-files/reels/brand/logo-redondo.png
FB=/usr/share/fonts/opentype/inter/Inter-Black.otf; FX=/usr/share/fonts/opentype/inter/Inter-ExtraBold.otf
Y=0xFFF40F; R=0xEB484D; GR=0x50C878; T=43.21
SH="I:balanza:0.5:0.5:1.0 2.3|I:correr:0.5:0.5:1.0 2.7|I:caminata:0.5:0.55:1.0 1.81|I:aburrida:0.5:0.45:1.0 1.04|I:cardio:0.5:0.5:1.0 1.1|I:zapatillas:0.5:0.65:1.0 1.2|I:grupo:0.5:0.55:1.0 1.85|c1 2.16|c3 2.44|I:musculo:0.5:0.5:1.0 1.71|I:funcional:0.5:0.5:1.0 1.69|I:funcional2:0.5:0.55:1.0 1.84|I:hiit:0.5:0.6:1.0 1.86|I:hiit2:0.5:0.45:1.0 1.25|I:hiit:0.5:0.6:1.5 1.24|c6 2.21|I:cinta:0.5:0.45:1.0 2.0|I:salud:0.5:0.42:1.0 1.7|c5 2.3|c4 1.1|I:evaluacion:0.5:0.5:1.0 2.46"
img(){ IFS=':' read _ n cx cy z0 <<< "$1"; N=$(python3 -c "print(round($2*30))")
 ffmpeg -v error -y -loop 1 -framerate 30 -i $IA/$n.jpg -t $2 -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='$z0*(1+0.09*on/$N)':x='max(0,min(iw-iw/zoom,$cx*iw-iw/zoom/2))':y='max(0,min(ih-ih/zoom,$cy*ih-ih/zoom/2))':d=1:s=1080x1920:fps=30,setsar=1" -c:v libx264 -crf 17 -preset fast -pix_fmt yuv420p -r 30 $3; }
i=0; : > list.txt; IFS='|'
for s in $SH; do IFS=' ' read f d <<< "$s"
 if [[ $f == I:* ]]; then img "$f" $d b$i.mp4
 else ffmpeg -v error -y -i $SRC/$f.mp4 -t $d -vf "tpad=stop_mode=clone:stop_duration=2,trim=0:$d,setpts=PTS-STARTPTS,setsar=1" -c:v libx264 -crf 17 -preset fast -pix_fmt yuv420p -r 30 b$i.mp4; fi
 echo "file b$i.mp4" >> list.txt; i=$((i+1)); IFS='|'; done; IFS=' '
ffmpeg -v error -y -f lavfi -i color=c=0x0D0D0D:s=1080x1920:d=5.25:r=30 -i $LOGO -filter_complex "[1:v]scale=400:-1[l];[0:v][l]overlay=(W-w)/2:260,drawtext=fontfile=$FX:text='TRABAJAMOS BAJO ESTRICTA':fontsize=54:fontcolor=white:x=(w-text_w)/2:y=760,drawtext=fontfile=$FB:text='EVALUACIÓN Y':fontsize=72:fontcolor=$Y:x=(w-text_w)/2:y=840,drawtext=fontfile=$FB:text='EVIDENCIA CIENTÍFICA':fontsize=72:fontcolor=$Y:x=(w-text_w)/2:y=930,drawbox=x=240:y=1080:w=600:h=110:color=$Y:t=fill,drawtext=fontfile=$FB:text='ESCRIBINOS':fontsize=64:fontcolor=0x0D0D0D:x=(w-text_w)/2:y=1103,setsar=1" -c:v libx264 -crf 17 -preset fast -pix_fmt yuv420p b$i.mp4
echo "file b$i.mp4" >> list.txt
ffmpeg -v error -y -f concat -safe 0 -i list.txt -c copy body.mp4
OFF="0.3,2.3,6.81,10.15,14.16,18.31,21.84,26.19,32.10,37.96"
python3 $F/subs-generico.py $F/words-lun-911-v4.json "$OFF" "5;1,5,8,11;2,4,7;3,8,9;1,2,6,9;1,2,7;1,2,6,10;3,6,8,11,16;3,7,11,13;4,7" subs.ass
A(){ echo "alpha='if(lt(t,$1),0,if(lt(t,$1+0.25),(t-$1)/0.25,if(gt(t,$2-0.2),max(0,($2-t)/0.2),1)))':enable='between(t,$1,$2)'"; }
SL(){ echo "$2+40*max(0,1-(t-$1)/0.3)"; }
P1(){ echo "drawtext=fontfile=$FB:expansion=none:text='$1':fontsize=66:fontcolor=0x0D0D0D:box=1:boxcolor=$Y:boxborderw=22:x=(w-text_w)/2:y='$(SL $2 170)':$(A $2 $3)"; }
P2(){ echo "drawtext=fontfile=$FB:expansion=none:text='$1':fontsize=60:fontcolor=white:shadowcolor=black@0.8:shadowx=3:shadowy=3:x=(w-text_w)/2:y='$(SL $2 285)':$(A $2 $3)"; }
CH(){ echo "drawtext=fontfile=$FB:expansion=none:text='$1':fontsize=62:fontcolor=$6:box=1:boxcolor=$5:boxborderw=24:x='(w-text_w)/2-700*max(0,1-(t-$2)/0.25)':y=$4:$(A $2 $3)"; }
ST(){ echo "drawtext=fontfile=$FB:expansion=none:text='$1':fontsize='if(lt(t,$2+0.2),150-50*(t-$2)/0.2,100)':fontcolor=$6:box=1:boxcolor=$5:boxborderw=34:x=(w-text_w)/2:y=$4-text_h/2:$(A $2 $3)"; }
TAG(){ echo "drawtext=fontfile=$FB:text='$1':fontsize=38:fontcolor=0x0D0D0D:box=1:boxcolor=$2:boxborderw=12:x=w-text_w-50:y=50:$(A $3 $4)"; }
ffmpeg -v error -y -i $LOGO -vf scale=120:-1 logo-s.png
cat > vf.txt <<EOT
[0:v][1:v]overlay=40:30:enable='lt(t,37.96)',
$(P1 '¿BAJAR DE PESO' 0.2 2.3),$(P2 'RÁPIDO?' 0.6 2.3),
$(ST 'EL ERROR' 3.85 6.81 760 $R white),$(CH 'SIN PLAN' 5.0 6.81 930 0x0D0D0D white),$(CH 'POR TU CUENTA' 5.9 6.81 1060 0x0D0D0D white),
$(CH 'ABURRIMIENTO' 6.95 10.15 700 $R white),$(CH 'ESTANCAMIENTO' 7.85 10.15 840 $R white),$(CH 'ABANDONO' 8.95 10.15 980 $R white),
$(P1 'TODO ESTÁ EN EL GIMNASIO' 10.25 14.16),$(ST 'GUARDALO' 13.1 14.16 820 $Y 0x0D0D0D),
$(P1 '1 · MUSCULACIÓN' 14.25 18.31),$(CH 'PRESERVÁ Y AUMENTÁ' 15.9 18.31 840 white 0x0D0D0D),$(CH 'TU MASA MUSCULAR' 17.0 18.31 980 $Y 0x0D0D0D),
$(P1 '2 · FUNCIONAL' 18.4 21.84),$(CH 'NUESTRA ESPECIALIDAD' 19.2 21.84 840 $Y 0x0D0D0D),$(CH 'TODO TU CUERPO' 20.1 21.84 980 white 0x0D0D0D),
$(P1 '3 · HIIT' 21.9 26.19),$(CH 'INTERVALOS CORTOS' 23.05 26.19 840 white 0x0D0D0D),$(CH 'A TU NIVEL' 25.35 26.19 980 $Y 0x0D0D0D),
$(CH 'PRESERVA TU MÚSCULO' 27.3 32.1 640 $GR 0x0D0D0D),$(CH 'REDUCÍS GRASA CORPORAL' 28.6 32.1 760 $GR 0x0D0D0D),$(CH 'CUIDA TU SALUD' 30.85 32.1 900 $Y 0x0D0D0D),
$(P1 'TE EVALUAMOS PRIMERO' 32.2 37.96),$(CH 'TU PLAN A MEDIDA' 34.6 37.96 760 white 0x0D0D0D),$(CH 'ESCRIBINOS' 35.8 37.96 900 $Y 0x0D0D0D),$(CH '"EVALUACIÓN"' 36.8 37.96 1040 $Y 0x0D0D0D),
null,
ass=subs.ass,
drawbox=x=0:y=1660:w=1080:h=6:color=$Y:t=fill,drawbox=x=0:y=1666:w=1080:h=170:color=0x0D0D0D@0.92:t=fill,
drawtext=fontfile=$FB:text='388-4499457':fontsize=60:fontcolor=$Y:x=(w-text_w)/2:y=1690,
drawtext=fontfile=$FX:text='FORMOSA 424 · EL CARMEN, JUJUY':fontsize=34:fontcolor=white:x=(w-text_w)/2:y=1768[v];
[2:a]atrim=0:$T,afade=t=in:d=0.3,afade=t=out:st=41.6:d=1.6,volume=0.8[a]
EOT
ffmpeg -v error -y -i body.mp4 -loop 1 -i $W/logo-s.png -ss 0 -i $M -filter_complex_script vf.txt -map "[v]" -map "[a]" -c:v libx264 -crf 19 -preset medium -pix_fmt yuv420p -c:a aac -b:a 192k -t $T -movflags +faststart final-subs.mp4
