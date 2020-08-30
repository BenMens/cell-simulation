package nl.benmens.cellsimulation;

import java.util.ArrayList;

import nl.benmens.processing.observer.SubscriptionManager;

public class Controller {
  private Controller parentController = null;
  protected ArrayList<Controller> childControllers = new ArrayList<Controller>();
  protected SubscriptionManager subscriptionManager = new SubscriptionManager();

  public Controller(Controller parent) {
    if (parent != null) {
      setParentController(parent);
    }
  }

  public final Controller getParentController() {
    return parentController;
  }

  public final void setParentController(Controller newParentController) {
    if (parentController != newParentController) {

      if (parentController != null) {
        parentController.childControllers.remove(this);
      }

      parentController = newParentController;

      if (parentController != null) {

        if (!parentController.childControllers.contains(this)) {
          parentController.childControllers.add(this);
        }
      }
    }
  }

  public final ArrayList<Controller> getChildControllers() {
    return childControllers;
  }

  public final void updateLayout() {
    beforeLayoutChildren();

    for (Controller child : childControllers) {
      child.updateLayout();
    }

    afterLayoutChildren();
  }

  public void beforeLayoutChildren() {
  }

  public void afterLayoutChildren() {
  }

  // ########################################################################
  // Destruction
  // ########################################################################
  public final void destroy() {
    this.setParentController(null);

    for (Controller childController : new ArrayList<Controller>(childControllers)) {
      childController.destroy();
    }

    onDestroy();
  }

  public void onDestroy() {
  }
}