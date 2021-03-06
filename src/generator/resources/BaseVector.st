/*
 * Copyright 2014 MovingBlocks
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.terasology.math.geom;

$if(componentType.discrete)$
import java.math.RoundingMode;

import com.google.common.math.DoubleMath;
$endif$
import com.google.common.base.Preconditions;

/**
 * A vector/point in $dimensions$D space
 * @author auto-generated
 */
public abstract class $vector/baseType()$ {

    /**
     * An immutable instance with all components set to 0
     */
    public static final $vector/immutableType()$ ZERO = new $vector/immutableType()$($comp/valueList(components, "0")$);
    
    /**
     * An immutable instance with all components set to 1
     */
    public static final $vector/immutableType()$ ONE = new $vector/immutableType()$($comp/valueList(components, "1")$);

$components:{x|
    /**
      * @return $x$ the $x$ coordinate
      */
    public abstract $componentType$ get$x.proper$(); };separator="\n"$

$components:{x|
    /**
      * @return $x$ the $x$ coordinate
      */
    public abstract $componentType$ $x$(); };separator="\n"$

$if(!componentType.discrete)$
    /**
     * @param a the first point
     * @param b the second point
     * @param t the interpolation value in the range [0..1]
     * @return the interpolated point
     */
    public static $vector/mutableType()$ lerp($vector/baseType()$ a, $vector/baseType()$ b, $componentType$ t) {
        Preconditions.checkArgument(t >= 0 && t <= 1, "t must be in range [0..1]");

        $components:{x| $componentType$ $x$ = a.get$x.proper$() * (1 - t) + b.get$x.proper$() * t; }; separator = "\n"$
        return new $vector/mutableType()$($components;separator=", "$);
    }
$else$
    /**
     * @param a the first point
     * @param b the second point
     * @param t the interpolation value in the range [0..1]
     * @param mode the rounding mode to use
     * @return the interpolated point
     */
    public static $vector/mutableType()$ lerp($vector/baseType()$ a, $vector/baseType()$ b, double t, RoundingMode mode) {
        Preconditions.checkArgument(t >= 0 && t <= 1, "t must be in range [0..1]");

        $components:{x| double $x$ = a.get$x.proper$() * (1 - t) + b.get$x.proper$() * t; }; separator = "\n"$

        return new $vector/mutableType()$(
$components:{x|
            DoubleMath.roundToInt($x$, mode)}; separator=",\n"$);
    }
$endif$

    /**
     * Returns the dot product of this vector and vector other.
     * @param other the other vector
     * @return the dot product of this and other
     */
    public final float dot($vector/baseType()$ other) {
        return (float) ($components:{x|this.get$x.proper$() * other.get$x.proper$()}; separator = " + "$);
    }


$if(!componentType.discrete)$
    /**
    * Returns the current vector projected onto v
    * @param v other vector to project onto
    *
    */
    public final $vector/mutableType()$ project( $vector/baseType()$ v)
    {
        return new $vector/mutableType()$(this).mul(this.dot(v)/ (this.length() * this.length()));
    }
$endif$

    /**
     * @return the squared distance to the origin
     */
    public $componentType$ lengthSquared() {
        return $components:{x| get$x.proper$() * get$x.proper$()};separator = " + "$;
    }

   /**
    *   Returns the angle in radians between this vector and the vector
    *   parameter; the return value is constrained to the range [0,PI].
    *   @param v1    the other vector
    *   @return   the angle in radians in the range [0,PI]
    */
   public final float angle($vector/baseType()$ v1) {
      double vDot = this.dot(v1) / (this.length() * v1.length());

      if (vDot < -1.0) {
          vDot = -1.0;
      }

      if (vDot >  1.0) {
          vDot =  1.0;
      }

      return (float) Math.acos(vDot);
   }

    /**
     * @return the distance to the origin
     */
    public $if(componentType.floatType)$float$else$double$endif$ length() {
        return $if(componentType.floatType)$(float) $endif$Math.sqrt(lengthSquared());
    }

    /**
     * @param other the other point
     * @return the distance in between
     */
    public $componentType$ distanceSquared($vector/baseType()$ other) {
        $components:{x|$componentType$ d$x$ = other.get$x.proper$() - this.get$x.proper$();}; separator = "\n"$

        return $components:{x| d$x$ * d$x$}; separator = " + "$;
    }

    /**
     * @param other the other point
     * @return the distance in between
     */
    public $if(componentType.floatType)$float$else$double$endif$ distance($vector/baseType()$ other) {
        return $if(componentType.floatType)$(float) $endif$Math.sqrt(distanceSquared(other));
    }

$if(componentType.discrete)$
    /**
     * @param other the other point
     * @return the grid distance in between (aka 1-Norm, Minkowski or Manhattan distance)
     */
    public int gridDistance($vector/baseType()$ other) {
        return $components:{x| Math.abs(other.get$x.proper$() - get$x.proper$())}; separator = " + "$;
    }
$endif$
    
    /**
     * Computes the distance between two points
     * @param p1 the first point
     * @param p2 the second point
     * @return the distance between the two points
     */
    public static $if(componentType.floatType)$float$else$double$endif$ distance($vector/baseType()$ p1, $vector/baseType()$ p2) {
        return p1.distance(p2);
    }

    /**
     * All point implementations with the same coordinate are equal
     */
    @Override
    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof $vector/baseType()$) {
            $vector/baseType()$ other = ($vector/baseType()$) obj;
$if(componentType.toIntegralFunc)$
            return $components:{x | $componentType.toIntegralFunc$(get$x.proper$()) == $componentType.toIntegralFunc$(other.get$x.proper$())}; separator = "\n                && "$;
$else$
            return $components:{x | get$x.proper$() == other.get$x.proper$()};separator = "\n                && "$;
$endif$
        }
        return false;
    }

    /**
     * All point implementations with the same coordinate have the same hashcode
     */
    @Override
    public final int hashCode() {
        int result = 1;
$if(componentType.toIntegralFunc)$
        final int prime = 31;
        long temp;
$components:{x |
        temp = $componentType.toIntegralFunc$(get$x.proper$());
        result = prime * result + (int) (temp ^ (temp >>> 32));
        }$
$else$
        final int prime = 1021;
        $components:{x |result = prime * result + get$x.proper$();}; separator = "\n"$
$endif$
        return result;
    }
    
    @Override
    public String toString() {
        return "(" + $components:{x | get$x.proper$()}; separator = " + \", \" + "$ + ")";
    }
}
