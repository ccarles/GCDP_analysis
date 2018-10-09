      program axis

*****************
*****************
*Author : Christian Carles

*Last update : 4 agust 2017

*this program calculates for each time step, masses of gas elements in
* concentric rings and calculates the bar strenght A_2.  

*It outputs profiles.out, giving for each time step, in each concentric
* ring, values off number of gas particle, gas mass of each element, 
*and gas total density within, and value of the A_2 parameter at such 
*radius 
*Format is : 
*one line for time, then nbin lines with : 
*1 :  nuber of the bin
*2 :  number of gas particles inside the radius
*3 :  number of stat particles inside the radius 
*4 :  central radius of the bin
*5 :  gas mass mg(index)
*6 :  star mass ms(index)
*7 :  density rhos
*8 :  mass H
*9 :  mass He
*10:  mass C
*11:  mass N
*12:  mass O
*13:  mass Ne
*14:  mass Mg
*15:  mass Si
*16:  mass Fe
*17:  mass Z total
*18:  O/H
*19:  Fe/H
*20:  A_2, bar strenght in gas
*21:  A_2, bar strenght in stars
*22:  A_2, bar strenght of both

*This program is tu be used with the following GCDP output ASCII files :
* tzstep.dat, gXXXXXX, sXXXXXX.


*use nbin and rmax to control number and spread of bins,
*******************

*opnening shit and declaring shit
      implicit double precision (a-h,m,o-z)
      parameter (nmax=1000000)
      parameter (rmax=20.)
      parameter (nbin=40)
      parameter (pi=3.14159265359)


      character filename *7
*arrays of all particles      
      dimension rs(nmax,3), ms(nmax), rg(nmax,3), mg(nmax), dist(nmax)
*arrays for each bin      
      dimension mass(nbin), ag(nbin), bg(nbin), as(nbin), bs(nbin),
     +          str(nbin), strg(nbin), strs(nbin), 
     +          msR(nbin), mgR(nbin), nsR(nbin), ngR(nbin)

      integer count(nbin)
      integer flagfld
      open(unit=9,file='tzstep.dat',status='old')
      open(unit=11,file='radial.out',status='unknown')
      open(unit=12,file='bar.out',status='unknown')
      read(9,9000) dummyc
 9000 format(a3)




*******************

*Read number of time steps , not counting first line
      tmax=1000
      N_dumps = 0
      DO i=1,tmax
      READ(9,*,IOSTAT=ios) junk
      IF (ios /= 0) EXIT
      N_dumps= N_dumps + 1
      ENDDO
      REWIND(9)
*write nuber of steps
      write(6,2301) N_dumps
 2301 format(3x,'Total numbr of simulated steps = ',i6)
      read(9,9000) dummyc


**************************


*Start big loop over all time dumps. l marks the dump number
      do l=1,N_dumps
           read(9,*,end=98) num, t
*WRITE at witch step we are on (6=terminal)
           write(6,2300) num, t
 2300      format(3x,'Working on dump ',i6,5x,'Time = ',1pe13.6)

* get the good filename for dump
           if(num.lt.10) then
                write(filename,8000) num
 8000           format('s00000',i1)
           else if(num.lt.100) then
                write(filename,8001) num
 8001           format('s0000',i2)
           else if(num.lt.1000) then
                write(filename,8002) num
 8002           format('s000',i3)
           else if(num.lt.10000) then
                write(filename,8003) num
 8003           format('s00',i4)
           else if(num.lt.100000) then
                write(filename,8004) num
 8004           format('s0',i5)
           else
                write(filename,8005) num
 8005           format('s',i6)
           endif


****************************


*open the star file, read position, mass, number of particles  

        open(unit=1,file=filename,status='old')
        ns=0
        do i=1,nmax
           read(1,*,end=98) (rs(i,j),j=1,3), (dummy,j=1,3), ms(i)
           ns=ns+1
        enddo
   98   close(unit=1)


* Open the gas file of our dump, read position, mass, number of
* particles
        filename(1:1)='g'
        open(unit=1,file=filename,status='old')
        ng=0
        do i=1,nmax
             read(1,*,end=99) x, y, z, (dummy,j=1,3), m,(dummy, j=1,12),
     +                         flagflg
*Feedback particles are stars not gas
             if(flagfld.eq.0) then
                  ng=ng+1
                  rg(ng,1)=x
                  rg(ng,2)=y
                  rg(ng,3)=z
                  mg(ng)=m
              else
                  ns=ns+1
                  rs(ns,1)=x
                  rs(ns,2)=y
                  rs(ns,3)=z
                  ms(ns)=m
            endif
        enddo
   99   close(unit=1)

****************************

*set the output and other needed values at 0
        asf=0.
        agf=0.
        bgf=0.
        bsf=0.
        strst=0.
        strgt=0.
        rsbar=0.
        dtrgt=0.
        rgbar=0.
        strt=0.
        rbar=0.
        dr=rmax/float(nbin)
        do index=1,nbin
            ag(index)=0.
            bg(index)=0.
            as(index)=0.
            bs(index)=0.
            ngR(index)=0.
            nsR(index)=0.
      ngrf=0.
      nsrf=0.
      msR(index)=0.
      mgR(index)=0.
      str(index)=0.
      strg(index)=0.
      strs(index)=0.
        end do 

**************************

*loop over gas
      do i=1,ng
*put stuff in kpc and solar masses
        rg(i,1)=100.*rg(i,1)
        rg(i,2)=100.*rg(i,2)
        rg(i,3)=100.*rg(i,3)
        mg(i)=1.e+12*mg(i)
*assign index to particle
      end do
      do i=1,ns
*stuff in kpc
        rs(i,1)=100.*rs(i,1)
        rs(i,2)=100.*rs(i,2)              
        rs(i,3)=100.*rs(i,3)
        ms(i)=1.e+12*ms(i)
      end do
  
      xcm=0.
      ycm=0.
      zcm=0.
      mstot=0.
      do i=1,ns
        xcm=xcm+rs(i,1)*ms(i)
        ycm=ycm+rs(i,2)*ms(i)
        zcm=zcm+rs(i,3)*ms(i)
        mstot=mstot+ms(i)
      enddo
      xcm=xcm/mstot
      ycm=ycm/mstot
      zcm=zcm/mstot


      do i=1,ng
        index=int(sqrt((rg(i,1)-xcm)**2+(rg(i,2)-ycm)**2)/dr)+1
*Add particle info to it's index annulus
        if (index.le.nbin) then
            delg=rg(i,2)/rg(i,1)
            del2g=delg**2
            ag(index)=ag(index)+(1.0-del2g)/(del2g+1.0)
            bg(index)=bg(index)+(2.0*delg)/(del2g+1.0)
            ngR(index)=ngR(index)+1.0
            mgR(index)=mgR(index)+mg(i)
        end if
      end do

********************************

*Loop over star particles
      do i=1,ns
* assign index to the particle
        index=int(sqrt((rs(i,1)-xcm)**2+(rs(i,2)-ycm)**2)/dr)+1
*Add particle info to it's index annulus
        if (index.le.nbin) then
              dels=rs(i,2)/rs(i,1)
              del2s=dels**2
              as(index)=as(index)+(1.0-del2s)/(del2s+1.0)
              bs(index)=bs(index)+(2.0*dels)/(del2s+1.0)
              nsR(index)=nsR(index)+1.0 
              msR(index)=msR(index)+ms(i)
        end if
      end do


*******************************

*Write time, then for each bin get str and write them up
      do index=1,nbin
*calculate radial values and r and sutff

       r1=float(index-1)*dr
       r=r1+0.5*dr
       r2=r1+dr
       rhos=msR(index)/(pi*(r2**2-r1**2))
       rhog=mgR(index)/(pi*(r2**2-r1**2))
*Calculate total a, b and n on each bin for 
       asf=asf+as(index)
       bsf=bsf+bs(index)
       nsrf=nsrf+nsR(index)
*calculate str stars
       strs(index)=sqrt(asf**2+bsf**2)/nsrf

*calculte total a, b and n of each bin for s
       agf=agf+ag(index)
       bgf=bgf+bg(index)
       ngrf=ngrf+ngR(index)
*calculate str stars
       strg(index)=sqrt(agf**2+bgf**2)/nsrf
*calculate str of both.               
       str(index)=sqrt(agf**2+bgf**2+asf**2+bsf**2)/(nsrf+ngrf)


*find the maximum str and radius for str/2 for stars

       if (strs(index).gt.strst) then
           strst=strs(index)
           rmaxbars=r
       end if
       if (strs(index).lt.0.8*strst .AND. r.gt.rmaxbars) then
           rsbar=r
       end if
*same for gas
       if (strg(index).gt.strgt) then
           strgt=strg(index)
           rmaxbarg=r
       end if
       if (strg(index).lt.0.8*strgt .AND. r.gt.rmaxbarg) then
           rgbar=r
       end if

       if (str(index).gt.strt) then
           strt=str(index)
           rmaxbar=r
       end if
       if (str(index).lt.0.8*strt .AND. r.gt.rmaxbar) then
           rbar=r
       end if


      write(11,3001) t, index, r, dr, ngR(index), ngrf,
     +               nsR(index),  nsrf, mgR(index), rhog, msR(index),
     +                       rhos, strg(index), strs(index), str(index) 
 3001         format(2x,1pe13.6,2x,i3,13(2x,1pe13.6)) 
            enddo
            write(12,3002) t, strst, rsbar, strgt, rgbar, strt, rbar
 3002       format(7(2x,1pe13.6))       
      enddo
      close(unit=11)
      close(unit=12)
      stop
      end
