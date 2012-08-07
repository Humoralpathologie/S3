package engine
{
  import flash.geom.Point;
  import flash.globalization.CollatorMode;
  
  /**
   * Utilities.
   * @author Roger Braun
   */
  public class Utils
  {
    
    // Straight port from http://lassieadventurestudio.wordpress.com/2012/03/20/polygon-hit-test/
    static public function polygonHitTest(p:Point, poly:Array):Boolean
    {
      var sides = poly.length, origin = new Point(0, p.y), hits = 0, s1, s2, i;
      
      // Test intersection of an external ray against each polygon side.
      for (i = 0; i < sides; i++)
      {
        s1 = poly[i];
        s2 = poly[(i + 1) % sides];
        origin.x = Math.min(origin.x, Math.min(s1.x, s2.x) - 1);
        hits += (intersection(origin, p, s1, s2) ? 1 : 0);
      }
      
      // Return true if an odd number of hits were found.
      return hits % 2 > 0;
    }
    
// Tests for counter-clockwise winding among three points.
// Specifically written for an intersection test:
// Uses ">=" (rather than ">") to cast equal points as valid CCW components.
    private static function ccw(x:Point, y:Point, z:Point):Boolean
    {
      return (z.y - x.y) * (y.x - x.x) >= (y.y - x.y) * (z.x - x.x);
    }
    
// Tests for intersection between line segments AB and CD.
    private static function intersection(a:Point, b:Point, c:Point, d:Point):Boolean
    {
      return ccw(a, c, d) !== ccw(b, c, d) && ccw(a, b, c) !== ccw(a, b, d);
    }
    
    public function Utils()
    {
    
    }
  
  }

}