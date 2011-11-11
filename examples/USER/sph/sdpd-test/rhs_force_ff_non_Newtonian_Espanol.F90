      SUBROUTINE rhs_force_ff_non_Newtonian_Espanol(this,&
           xi,xj,dij,vi,vj,numi,numj, pi,pj,&
           mi,mj,w,gradw,fi,fj,stat_info)
        
        !----------------------------------------------------
        ! Implements the viscous and thermal force from
        ! Espanol and Revenga model.
        ! With extra pressure tensor.
        !----------------------------------------------------
        
        TYPE(Rhs), INTENT(INOUT)                :: this
        REAL(MK), DIMENSION(:), INTENT(IN)      :: xi
        REAL(MK), DIMENSION(:), INTENT(IN)      :: xj
        REAL(MK), INTENT(IN)                    :: dij
        REAL(MK), DIMENSION(:), INTENT(IN)      :: vi
        REAL(MK), DIMENSION(:), INTENT(IN)      :: vj
        !number density 
        REAL(MK), INTENT(IN)                    :: numi
        REAL(MK), INTENT(IN)                    :: numj
        REAL(MK), DIMENSION(:,:), INTENT(IN)    :: pi
        REAL(MK), DIMENSION(:,:), INTENT(IN)    :: pj
        REAL(MK), INTENT(IN)                    :: mi
        REAL(MK), INTENT(IN)                    :: mj
        REAL(MK), INTENT(IN)                    :: w
        REAL(MK), INTENT(IN)                    :: gradw
        REAL(MK), DIMENSION(:), INTENT(INOUT)   :: fi
        REAL(MK), DIMENSION(:), INTENT(INOUT)   :: fj
        INTEGER, INTENT(OUT)                    :: stat_info
        
        !----------------------------------------------------
        ! Local variables.
        !----------------------------------------------------
        
        INTEGER                         :: stat_info_sub
        INTEGER                         :: num_dim
        REAL(MK)                        :: dt
        REAL(MK)                        :: eta
        REAL(MK)                        :: kt
        REAL(MK), DIMENSION(3)          :: eij
        REAL(MK), DIMENSION(3)          :: vij
        REAL(MK), DIMENSION(3)          :: f_c
        REAL(MK)                        :: f_d
        REAL(MK), DIMENSION(3)          :: f_r
        REAL(MK), DIMENSION(3,3)        :: dW
        REAL(MK)                        :: trace, a,b,Zij,Aij,Bij
        REAL(MK), DIMENSION(3)          :: We    
        INTEGER                         :: i,j
        
        !----------------------------------------------------
        ! Initialization of variables.
        !----------------------------------------------------
        
        stat_info     = 0
        stat_info_sub = 0
        
        fi(:) = 0.0_MK
        fj(:) = 0.0_MK
        
        num_dim = this%num_dim
        
        dt   = this%dt
        eta  = physics_get_eta(this%phys,stat_info_sub)     
        kt   = this%kt
        
        !----------------------------------------------------
        ! Check if any denominator is non-positive.
        !----------------------------------------------------
        
        IF ( dij < mcf_machine_zero .OR. &
             mi < mcf_machine_zero .OR. &
             mj < mcf_machine_zero .OR. &
             numi < mcf_machine_zero .OR. &
             numj < mcf_machine_zero ) THEN
           
           PRINT *,"xi,xj,dij : ",  xi,xj,dij
           PRINT *,"vi,vj : ", vi,vj
           PRINT *,"numi,numj : ", numi,numj
           PRINT *,"pi,pj : ", pi,pj
           PRINT *,"mi,mj : ", mi,mj
           PRINT *,"w, gradw : ", w, gradw          
           
           stat_info = -1
           GOTO 9999
        END IF
        
        !----------------------------------------------------
        ! Calculate normalized vector pointing from j to i.
        !----------------------------------------------------
        
        eij(1:num_dim) = (xi(1:num_dim) - xj(1:num_dim)) / dij
        
        !----------------------------------------------------
        ! Calculate velocity vector pointing from j to i.
        !----------------------------------------------------
        
        vij(1:num_dim) = vi(1:num_dim) - vj(1:num_dim)
        
        !----------------------------------------------------
	! Calculate the conservative force
	! per unit mass(from pressure).
  	!----------------------------------------------------
        
        f_c(1:num_dim) = 0.0_MK
        
        DO j = 1, num_dim
           DO i = 1, num_dim
              f_c(j) = f_c(j) + &
                   pi(i,j) * eij(i) / (numi**2.0_MK) +  &
                   pj(i,j) * eij(i) /( numj**2.0_MK)              
           END DO
        END DO
        
        fi(1:num_dim) = fi(1:num_dim) - &
             f_c(1:num_dim) * gradw / mi
        fj(1:num_dim) = fj(1:num_dim) + &
             f_c(1:num_dim) * gradw / mj
        
        !----------------------------------------------------
        ! Calculate the dissipative force
	! per unit mass(from viscosity).
  	!----------------------------------------------------
        
        f_d =  eta * (1.0_MK/numi**2.0_MK + &
             1.0_MK/numj**2.0_MK) * gradw / dij
        
        fi(1:num_dim) = fi(1:num_dim) + &
             f_d  * vij(1:num_dim) / mi
        fj(1:num_dim) = fj(1:num_dim) - &
             f_d  * vij(1:num_dim) / mj
        
        !----------------------------------------------------
        ! Calculate random force
	! per unit mass(from thermal noise),
        ! if kt is above zero.
  	!----------------------------------------------------
        
        IF ( this%Brownian .AND. &
             kt >  mcf_machine_zero ) THEN
           
           !-------------------------------------------------
           ! Generate the 2*2(2D) or 
           ! 3*3(3D) matrix
           ! dW with 4 or 9 random numbers.
           ! Calculate the trace.
           !-------------------------------------------------
           
           trace = 0.0_MK
           
           DO i=1, num_dim
              DO j = 1, num_dim
                 dW(i,j) = random_random(this%random,stat_info_sub)
              END DO
              trace = trace + dw(i,i)
           END DO
           
           trace = trace / num_dim
           
           !-------------------------------------------------
           ! Make the matrix dW symmetric 
           ! and traceless.
           !-------------------------------------------------
           
           DO i =1,num_dim
              DO j = i+1,num_dim
                 dW(i,j) = (dW(i,j) + dW(j,i)) / 2.0_MK
                 dW(j,i) = dW(i,j)
              END DO
              dW(i,i) = dW(i,i) - trace
           END DO

           Zij = 4.0_MK*kt*gradW/dij/numi/numj
           a   = 5.0_MK *eta/3.0_MK
           b   = (DFLOAT(num_dim) + 2.0_MK)*eta/ 3.0_MK
           Aij = SQRT(-Zij * a)
           Bij = SQRT(-Zij*DFLOAT(num_dim)/2.0_MK * &
                (b+a*(2.0_MK/DFLOAT(num_dim) -1.0_MK)))
           
           !-------------------------------------------------
           ! Generate the vector by
           ! dot product of dW and eij.  
           !-------------------------------------------------
           
           DO i = 1, num_dim
              We(i) = 0.0_MK
              DO j = 1, num_dim
                 We(i) = We(i) + dW(i,j) * eij(j)
              END DO
           END DO

           f_r(1:num_dim) = (Aij * We(1:num_dim) + Bij*trace*eij(1:num_dim)) / &
                SQRT(dt)
           fi(1:num_dim) = fi(1:num_dim) + f_r(1:num_dim) / mi
           fj(1:num_dim) = fj(1:num_dim) - f_r(1:num_dim) / mj 
           
        END IF ! Brownian and kt > 0
        
9999    CONTINUE
        
        RETURN
        
      END SUBROUTINE rhs_force_ff_non_Newtonian_Espanol
      
