      program sfr_evol
*
*****************
*Author : Christian Carles

*Last update : 1 june 2017

*this program calculates the evolution of the SFR inside a fiber region (central 1kpc) and whole galaxy. 

*It outputs sfr_evol2.out, giving for each time step  the star formation within the first zone of your sfr_profile (default=central kpc) and whole galaxy. Format :  t, sfr_fiber, sfr_global

*This program is tu be used with the following GCDP output ASCII files :
*sfr_profile.out

*******************

* This profile calculates the time-evolution of the SFR inside the
* fiber regionand inside the whole galaxy, using the output of
* sfr_profile.f
*
      implicit double precision (a-h,m,o-z)

      open(unit=4,file='sfr_evol.out',status='unknown')
      open(unit=9,file='sfr_profile.out',status='old')


*read number of lines in sfr_profile to loop them.
      nline=0
      do i=1,1000000
      READ(9,IOSTAT=ios) junk
      if (ios/=0) EXIT
      nline=nline+1
      enddo
      rewind(9)
      print*, nline

*set inital values of stuff
      t_old=0.02
      sfr_fiber=0.
      sfr_global=0.

*loop over all lines and read data
      do k=1,nline
           read(9,*,end=98) t, dist, dr,  g, s, sfr
*if we have the right current timestep, add up all bins
           if (t.eq.t_old) then
*add bins to the global SFR of this timestep and to the central if
*distace is ok
               if (dist.lt.1.001) sfr_fiber=sfr_fiber+sfr
                  sfr_global=sfr_global+sfr
            else
*if the time changed, it meas we did all bins. Write the time in
*terminal and the cumulated data in sfr_evol.
               write(6,2300) t_old
 2300          format(5x,'Time = ',1pe13.6)
               write(4,3000) t_old, sfr_fiber, sfr_global
 3000          format(3(2x,1pe13.6))
*we need to keep te new data we just read and crush the old data we
*don't need.
               if (dist.lt.1.001) then
                    sfr_fiber=sfr
                    else
                    sfr_fiber=0.
               end if 
               sfr_global=sfr
*change reference time to get into the right loop
               t_old=t
           end if
      enddo

   98 close(unit=4)
      close(unit=9)

      stop
      end
