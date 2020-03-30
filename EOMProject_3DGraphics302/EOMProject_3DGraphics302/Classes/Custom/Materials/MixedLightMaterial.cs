using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Sample;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EOMProject_3DGraphics302.Classes.Custom.Materials
{
    public class MixedLightMaterial : Material
    {
        #region Properties

        public Color DirectionalLightColor { get; set; }
        public Vector3 DirectionalLightDirection { get; set; }
        public Texture DiffuseTextureOne { get; set; }
        public Texture NormalTexture { get; set; }

        public Vector3 CameraPosition { get; set; }

        #endregion

        public override void SetEffectParameters(Effect effect)
        {
            if (effect.Parameters["DirectionalLightColor"] != null)
                effect.Parameters["DirectionalLightColor"].SetValue(DirectionalLightColor.ToVector3());

            if (effect.Parameters["DirectionalLightDirection"] != null)
                effect.Parameters["DirectionalLightDirection"].SetValue(DirectionalLightDirection);

            if (effect.Parameters["DiffuseTextureOne"] != null)
                effect.Parameters["DiffuseTextureOne"].SetValue(DiffuseTextureOne);

            if (effect.Parameters["NormalTexture"] != null)
                effect.Parameters["NormalTexture"].SetValue(NormalTexture);

            if (effect.Parameters["CameraPosition"] != null)
                effect.Parameters["CameraPosition"].SetValue(CameraPosition);

            base.SetEffectParameters(effect);
        }

        public override void Update()
        {
            //for (int i = 0; i < PointLightPositions.Length; i++)
            //{
            //    DebugEngine.AddBoundingSphere(new BoundingSphere(PointLightPositions[i], PointLightAttenuations[i]), PointLightColors[i]);
            //    DebugEngine.AddBoundingSphere(new BoundingSphere(PointLightPositions[i], 1f), Color.DarkMagenta);
            //}

            base.Update();
        }

        public void UpdateCamera(Vector3 cameraPosition)
        {
            CameraPosition = cameraPosition;
        }

    }

    public class ColorMaterial : Material
    {
        public Color Color { get; set; }
        public Texture2D Texture { get; set; }
        public Texture2D Texture2 { get; set; }
        public Vector2 UVOffset { get; set; }

        public override void SetEffectParameters(Effect effect)
        {
            //color 0 - 255
            //gpu 0 - 1

            if (effect.Parameters["Color"] != null)
                effect.Parameters["Color"].SetValue(Color.ToVector3());

            if (effect.Parameters["Texture"] != null)
                effect.Parameters["Texture"].SetValue(Texture);

            if (effect.Parameters["Texture2"] != null)
                effect.Parameters["Texture2"].SetValue(Texture2);

            if (effect.Parameters["UVOffset"] != null)
                effect.Parameters["UVOffset"].SetValue(UVOffset);

            base.SetEffectParameters(effect);
        }

        public override void Update()
        {
            //Set scroll here
            UVOffset += new Vector2(0.0001f, 0.0001f);
            base.Update();
        }
    }


    public static class Extensions 
    {
        public static Vector3[] ToVector3(this Color[] clrs)
        {
            Vector3[] vectors = new Vector3[clrs.Length];
            for (int i = 0; i < clrs.Length; i++)
            {
                vectors[i] = clrs[i].ToVector3();
            }

            return vectors;
        }
    }
}
