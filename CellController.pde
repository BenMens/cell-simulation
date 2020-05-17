class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    ArrayList<ActionController> actionControllers = new ArrayList<ActionController>();


    CellController(CellModel cellModel) {
        this.cellModel = cellModel;
        this.cellView = new CellView(cellModel);

        this.cellModel.registerClient(this);
        this.cellView.registerClient(this);
    }


    void onAddAction(ActionBaseModel actionModel) {
        ActionController newActionController = new ActionController(actionModel);
        cellView.addChildView(newActionController.actionView);

        actionControllers.add(newActionController);
    }


    void tick() {
    }

}
