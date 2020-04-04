#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_3
#endif

#define PL_AMT 2
//Using define PL_AMT (Point Light Amount) to set array size, allows pipeline to build the effect

matrix World;
matrix View;
matrix Projection;

//Point Light
float3 PointLightPositions[PL_AMT] = { float3(0, 0, 0), float3(0, 0, 0) };
 
float PointLightAttenuations[PL_AMT] = { 80, 40 };
float3 PointLightColors[PL_AMT] = { float3(1, 1, 1), float3(250, 1, 1) };

float PointLightFallOff = 2; //Inverse square law value

//Directional Light
float3 DirectionalLightColor = float3(1, 0, 0);
float3 DirectionalLightDirection = float3(0, 0, 1);

//Common
float3 DiffuseColor = float3(1, 1, 1);
float3 AmbientColor = float3(.15, .15, .15);

Texture2D DiffuseTextureOne;
Texture2D DiffuseTextureTwo;
Texture2D NormalTexture;

float3 CameraPosition;
float3 SpecularColor = float3(0, 0, 0);
float SpecularPower = 40;

sampler DiffuseTextureSamplerOne = sampler_state
{
    texture = <DiffuseTexture>;
};

sampler DiffuseTextureSamplerTwo = sampler_state
{
    texture = <DiffuseTextureTwo>;
};

sampler NormalTextureSampler = sampler_state
{
    texture = <NormalTexture>;
};

//Struct Decleration
struct VertexShaderInput
{
	float4 Position : POSITION0;
    float2 UV : TEXCOORD0;
    float3 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
    float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
    float3 ViewDirection : TEXCOORD3;
};



//Main Vertex Shader
VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output;

	float4 worldPos = mul(input.Position, World);
	float4 viewPos = mul(worldPos, View);
	output.Position = mul(viewPos, Projection);

    output.Normal = mul(input.Normal, World);
    output.Normal = normalize(output.Normal);
	output.WorldPosition = worldPos;
	output.UV = input.UV;
    output.ViewDirection = normalize(worldPos.xyz - CameraPosition); //Used for specular light calculations

	return output;
}

//Calculates Diffuse Color for Pixel Shader
float3 CalculateDiffuse(float2 UV)
{
    float3 textureColor = DiffuseTextureOne.Sample(DiffuseTextureSamplerOne, UV);
    textureColor.rgb *= DiffuseColor.rgb;
    
    //Overlaying second diffuse texture
    textureColor.rgb *= DiffuseTextureTwo.Sample(DiffuseTextureSamplerTwo, UV).rgb;
    
    
    return textureColor;
}

//Point Light Calculation Method
float3 CreatePointLight(VertexShaderOutput input, float3 lightPosition, float3 lightColor, float att, float3 normalData) : COLOR
{
    float3 LightingColor = AmbientColor; //Color when there isn't any light. 
    float3 LightingDirection = normalize(lightPosition - input.WorldPosition);
    
    //Specular Calculations
    float3 LightingIntensity = saturate(dot(LightingDirection, normalData)) * LightingColor;
    float3 ReflectionAngle = reflect(LightingDirection, normalData); //Angle between light direction and surface normal.
    float3 SpecularLight = pow(saturate(dot(ReflectionAngle, input.ViewDirection)), SpecularPower) * SpecularColor;
    
    //Attenuation Calculations
    float3 DistanceToLight = distance(lightPosition, input.WorldPosition);
    float LightingAttenuation = 1 - pow(clamp(DistanceToLight / att, 0, 1), PointLightFallOff); //Inverse square law -> how much light will the vertex recieve
    
    return saturate(lightColor + SpecularLight + LightingIntensity) * LightingAttenuation; //Diffuse Color Applied in final calculation

}

//Directional Light Calculation Method
float3 DirectionalLightWithSpecular(VertexShaderOutput input, float3 normalData) : COLOR
{
    float3 ObjectColor = DiffuseColor;
    ObjectColor *= DiffuseTextureOne.Sample(DiffuseTextureSamplerOne, input.UV);
    
    float3 LightingColor = AmbientColor; //Color when there isn't any light.
    float3 LightDirection = normalize(DirectionalLightDirection);
    
    //Specular Calculations
    float3 intensity = saturate(dot(LightDirection, normalData)) * DirectionalLightColor;
    float3 ReflectionAngle = reflect(LightDirection, normalData); //Angle between light direction and surface normal.
    float3 SpecularLight = pow(saturate(dot(ReflectionAngle, input.ViewDirection)), SpecularPower) * SpecularColor;
    
    return saturate(((LightingColor + intensity) + SpecularLight)) * ObjectColor;
   
}


//Main Pixel Shader
float4 MainPS(VertexShaderOutput input):COLOR
{
    //Normal Calculations
    float3 Normal = tex2D(NormalTextureSampler, input.UV).rgb;
    Normal = (Normal * 2) - 1; //Shift value to -1,1 range.
    
    //Color Calcuations
    float3 FinalColor = CalculateDiffuse(input.UV); //Inital Diffuse
    FinalColor += DirectionalLightWithSpecular(input, input.Normal);
    FinalColor += CreatePointLight(input, PointLightPositions[0], PointLightColors[0], PointLightAttenuations[0], Normal);
    FinalColor += CreatePointLight(input, PointLightPositions[1], PointLightColors[1], PointLightAttenuations[1], Normal);
    
    return float4(FinalColor, 1);
}



technique Main
{
    pass P0
    {
        VertexShader = compile VS_SHADERMODEL MainVS();
        PixelShader = compile PS_SHADERMODEL MainPS();
    }
};

