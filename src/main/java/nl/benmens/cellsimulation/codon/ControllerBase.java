package nl.benmens.cellsimulation.codon;

import java.util.ArrayList;

public class ControllerBase {
  private ControllerBase parentController = null;
  protected ArrayList<ControllerBase> childControllers = new ArrayList<ControllerBase>();

  public ControllerBase(ControllerBase parent) {
    if (parent != null) {
      setParentController(parent);
    }
  }

  public final ControllerBase getParentController() {
    return parentController;
  }

  public final void setParentController(ControllerBase newParentController) {
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

  public final ArrayList<ControllerBase> getChildControllers() {
    return childControllers;
  }

  public final void updateLayout() {
    beforeLayoutChildren();

    for (ControllerBase child : childControllers) {
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

    for (ControllerBase childController : (ArrayList<ControllerBase>) childControllers.clone()) {
      childController.destroy();
    }

    onDestroy();
  }

  public void onDestroy() {
  }
}