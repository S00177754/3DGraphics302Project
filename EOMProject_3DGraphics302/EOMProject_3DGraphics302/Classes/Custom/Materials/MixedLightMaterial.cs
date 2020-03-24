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

        public Vector3[] PointLightPositions { get; set; } = new Vector3[2];
        public float[] PointLightAttenuations { get; set; } = new float[2];
        public Color[] PointLightColors { get; set; } = new Color[2];
        public float PointLightFallOff { get; set; }

        public Color DirectionalLightColor { get; set; }
        public Vector3 DirectionalLightDirection { get; set; }

        public Color AmbientColor { get; set; }
        public Color DiffuseColor { get; set; }

        public Texture DiffuseTextureOne { get; set; }
        public Texture DiffuseTextureTwo { get; set; }
        public Texture NormalTexture { get; set; }

        public Color SpecularColor { get; set; }
        public float SpecularPower { get; set; }
        #endregion

        public override void SetEffectParameters(Effect effect)
        {
            if (effect.Parameters["PointLightPositions"] != null)
                effect.Parameters["PointLightPositions"].SetValue(PointLightPositions);

            if (effect.Parameters["PointLightAttenuations"] != null)
                effect.Parameters["PointLightAttenuations"].SetValue(PointLightAttenuations);

            if (effect.Parameters["PointLightColors"] != null)
                effect.Parameters["PointLightColors"].SetValue(PointLightColors.ToVector3());

            if (effect.Parameters["PointLightFallOff"] != null)
                effect.Parameters["PointLightFallOff"].SetValue(PointLightFallOff);

            if (effect.Parameters["DirectionalLightColor"] != null)
                effect.Parameters["DirectionalLightColor"].SetValue(DirectionalLightColor.ToVector3());

            if (effect.Parameters["DirectionalLightDirection"] != null)
                effect.Parameters["DirectionalLightDirection"].SetValue(DirectionalLightDirection);

            if (effect.Parameters["AmbientColor"] != null)
                effect.Parameters["AmbientColor"].SetValue(AmbientColor.ToVector3());

            if (effect.Parameters["DiffuseColor"] != null)
                effect.Parameters["DiffuseColor"].SetValue(DiffuseColor.ToVector3());

            if (effect.Parameters["DiffuseTextureOne"] != null)
                effect.Parameters["DiffuseTextureOne"].SetValue(DiffuseTextureOne);

            if (effect.Parameters["DiffuseTextureTwo"] != null)
                effect.Parameters["DiffuseTextureTwo"].SetValue(DiffuseTextureTwo);

            if (effect.Parameters["NormalTexture"] != null)
                effect.Parameters["NormalTexture"].SetValue(NormalTexture);

            if (effect.Parameters["SpecularColor"] != null)
                effect.Parameters["SpecularColor"].SetValue(SpecularColor.ToVector3());

            if (effect.Parameters["SpecularPower"] != null)
                effect.Parameters["SpecularPower"].SetValue(SpecularPower);

            base.SetEffectParameters(effect);
        }

        public override void Update()
        {
            for (int i = 0; i < PointLightPositions.Length; i++)
            {
                DebugEngine.AddBoundingSphere(new BoundingSphere(PointLightPositions[i], PointLightAttenuations[i]), PointLightColors[i]);
            }

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
