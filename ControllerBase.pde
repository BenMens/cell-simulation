class ControllerBase {
    private ControllerBase parentController = null;
    protected ArrayList<ControllerBase> childControllers = new ArrayList<ControllerBase>();

    ControllerBase(ControllerBase parent) {
        if (parent != null) {
            setParentController(parent);
        }
    }


    final ControllerBase getParentController() {
        return parentController;
    }


    final void setParentController(ControllerBase newParentController) {
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


    final ArrayList<ControllerBase> getChildControllers() {
        return childControllers;
    }


    final void updateLayout() {
        beforeLayoutChildren();

        for (ControllerBase child: childControllers) {
            child.updateLayout();
        }

        afterLayoutChildren();
    }

    void beforeLayoutChildren() {}

    void afterLayoutChildren() {}

    // ########################################################################
    // Destruction
    // ########################################################################
    final void destroy() {
        this.setParentController(null);

        for (ControllerBase childController: (ArrayList<ControllerBase>)childControllers.clone()) {
            childController.destroy();
        }


        onDestroy();
    }

    void onDestroy() {}
}
