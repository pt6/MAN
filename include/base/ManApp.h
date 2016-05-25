#ifndef MANAPP_H
#define MANAPP_H

#include "MooseApp.h"

class ManApp;

template<>
InputParameters validParams<ManApp>();

class ManApp : public MooseApp
{
public:
  ManApp(InputParameters parameters);
  virtual ~ManApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* MANAPP_H */
