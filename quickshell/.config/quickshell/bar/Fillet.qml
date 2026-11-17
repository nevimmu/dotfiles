import QtQuick
import QtQuick.Shapes

// Concave (inverted) corner joining the bar's right edge to the panel's above or bottom edge.
// Placed with its left edge at the bar's right edge; overlaps the bar by `ov` px to avoid seams.
Shape {
    id: root

    property real size: 14
    property bool above: true // true: sits above the panel, false: below it
    property color color: "white"
    readonly property real ov: 1

    width: size + ov
    height: size
    visible: size > 0.5
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        fillColor: root.color
        strokeWidth: -1

        startX: 0
        startY: root.above ? 0 : root.size
        PathLine { x: 0; y: root.above ? root.size : 0 }
        PathLine { x: root.size + root.ov; y: root.above ? root.size : 0 }
        PathArc {
            x: root.ov
            y: root.above ? 0 : root.size
            radiusX: root.size
            radiusY: root.size
            direction: root.above ? PathArc.Clockwise : PathArc.Counterclockwise
        }
        PathLine { x: 0; y: root.above ? 0 : root.size }
    }
}
