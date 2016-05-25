#include "ManApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template<>
InputParameters validParams<ManApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  params.set<bool>("use_legacy_output_syntax") = false;

  return params;
}

ManApp::ManApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  ManApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  ManApp::associateSyntax(_syntax, _action_factory);
}

ManApp::~ManApp()
{
}

// External entry point for dynamic application loading
extern "C" void ManApp__registerApps() { ManApp::registerApps(); }
void
ManApp::registerApps()
{
  registerApp(ManApp);
}

// External entry point for dynamic object registration
extern "C" void ManApp__registerObjects(Factory & factory) { ManApp::registerObjects(factory); }
void
ManApp::registerObjects(Factory & factory)
{
}

// External entry point for dynamic syntax association
extern "C" void ManApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { ManApp::associateSyntax(syntax, action_factory); }
void
ManApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
