[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  nz = 0
  xmin = 5
  xmax = 45
  ymin = 5
  ymax = 45
  elem_type = QUAD4
  uniform_refine = 1
[]

[Variables]

  [./c]
    order = FIRST
    family = LAGRANGE
  [./InitialCondition]
    x1 = 25
    y1 = 25
    radius = 5
    outvalue = .2
    variable = c
    invalue = .33
    type = SmoothCircleIC
  [../]


  [../]

  [./w]
    order = FIRST
    family = LAGRANGE
  [../]

  [./eta]
    order = FIRST
    family = LAGRANGE
  [./InitialCondition]
    x1 = 25
    y1 = 25
    radius = 5
    outvalue = 0
    variable = eta
    invalue = 1
    type = SmoothCircleIC
  [../]



  [../]
[]



[AuxVariables]
  [./f_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]


[AuxKernels]
  [./f_density]
    type = TotalFreeEnergy
    variable = f_density
    interfacial_vars = c
    kappa_names = kappa_c
  [../]
[]

[Kernels]
  [./detadt]
    type = TimeDerivative
    variable = eta
  [../]
  [./ACBulk]
    type = AllenCahn
    variable = eta
    args = c
    f_name = F
    mob_name = L
  [../]
  [./anisoACinterface1]
    type = ACInterfaceKobayashi1
    variable = eta
    mob_name = L
  [../]
  [./anisoACinterface2]
    type = ACInterfaceKobayashi2
    variable = eta
    mob_name = L
  [../]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
    args = eta
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'L M kappa_c'
    prop_values = '1.0 4.0 3.826'
  [../]
  [./aniso_material]
    type = InterfaceOrientationMaterial
    block = 0
    c = c
    mode_number = 2
    eps_bar = 0.02
  [../]
  [./free_energy_A]
    type = DerivativeParsedMaterial
    block = 0
    f_name = Fa
    args = c
    function = 1622.6*c^2-6.4904*c-9.0399
    derivative_order = 2
    enable_jit = true
  [../]
  [./free_energy_B]
    type = DerivativeParsedMaterial
    block = 0
    f_name = Fb
    args = c
    function = 95.615+948.52*c^2-630.06*c
    derivative_order = 2
    enable_jit = true
  [../]
  [./free_energy]
    type = DerivativeTwoPhaseMaterial
    block = 0
    f_name = F
    fa_name = Fa
    fb_name = Fb
    args = c
    eta = eta
    derivative_order = 2
    outputs = exodus
    W = 1.0
  [../]
  [./switching]
    type = SwitchingFunctionMaterial
    block = 0
    eta = eta
    h_order = SIMPLE
  [../]
  [./barrier]
    type = BarrierFunctionMaterial
    block = 0
    eta = eta
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON
  l_max_its = 15
  l_tol = 1.0e-4
  nl_max_its = 10
  nl_rel_tol = 1.0e-11
  start_time = 0.0
  num_steps = 500
  dt = .0001
  [./Adaptivity]
    coarsen_fraction = 0.1
    refine_fraction = 0.7
    max_h_level = 1
  [../]
[]

[Postprocessors]
  [./ElementInt_c]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
  [./Element_int_eta]
    type = ElementIntegralVariablePostprocessor
    variable = eta
  [../]
  [./total_F]
    type = ElementIntegralVariablePostprocessor
    variable = f_density
  [../]
[]

[Outputs]
  exodus = true
  csv = true
[]

