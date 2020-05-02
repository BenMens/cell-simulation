class BodyController implements BodyModelClient, BodyViewClient {
    BodyModel bodyModel;
    BodyView bodyView;

    ArrayList<CellController> cellControllers = new ArrayList<CellController>();


    BodyController(BodyModel bodyModel) {
        this.bodyModel = bodyModel;
        this.bodyView = viewFactory.createView(bodyModel);

        this.bodyModel.registerClient(this);
        this.bodyView.registerClient(this);
    }


    void tick() {
        for (CellController cellController: cellControllers) {
            cellController.tick();
        }
    }


    void onAddCell(BodyModel bodyModel, CellModel cellModel) {
        CellController newCellController = new CellController(cellModel);
        bodyView.addChildView(newCellController.cellView);

        cellControllers.add(newCellController);
    }
}
