#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix View;
matrix Projection;

float3 DiffuseColor = float3(1, 1, 1);
float3 AmbientColor = float3(0.15, 0.15, 0.15);

float3 Position = float3(40, 5, 10);
float3 PositionTwo = float3(20, 5, -10);

float3 LightColor = float3(1, 1, 1);
float3 LightColorTwo = float3(250, 1, 1);

float Attenuation = 80;
float AttenuationTwo = 40;

float FallOff = 2;

texture Texture;
sampler TextureSampler = sampler_state
{
    texture = <Texture>;
};

texture TextureTwo;
sampler TextureTwoSampler = sampler_state
{
    texture = <TextureTwo>;
};

texture NormalTexture;
sampler NormalSampler = sampler_state
{
    texture = <NormalTexture>;
};

//Phong lighting
float3 CameraPosition;
float3 SpecularColor = float3(1, 1, 1);
float3 SpecularPower = 64;

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
    float3 WorldPosition : TEXCOORD2; //world position of vertex
    float3 ViewDirection : TEXCOORD3;
    float3 LightPosOne : TEXCOORD4;
    float3 LightPosTwo : TEXCOORD5;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
    VertexShaderOutput output;

    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);

    output.Position = mul(viewPosition, Projection);
    output.WorldPosition = worldPosition;
    output.Normal = mul(input.Normal, World);
    output.ViewDirection = normalize(worldPosition.xyz - CameraPosition);
    output.UV = input.UV;
    
    output.LightPosOne = Position.xyz - worldPosition.xyz;
    output.LightPosTwo = PositionTwo.xyz - worldPosition.xyz;
    output.LightPosOne = normalize(output.LightPosOne);
    output.LightPosTwo = normalize(output.LightPosTwo);
    
    return output;
}

float4 PointLightCalculation(VertexShaderOutput input, float3 normal, float3 lightPos,float3 lightColor, float lightAttenuation,float3 diffuseColor)
{
    float3 intensity = saturate(dot(normal, lightPos)) * lightColor;
    float3 reflection = reflect(lightPos, normal);
    float3 lighting = pow(saturate(dot(reflection, input.ViewDirection)), SpecularPower) * SpecularColor;
    float dist = distance(Position, input.WorldPosition);
    float attenuation = 1 - pow(clamp(dist / lightAttenuation, 0, 1), FallOff);
    lighting += intensity;
    return float4(saturate(lighting * attenuation * diffuseColor), 1);
}


float4 MainPS(VertexShaderOutput input) : COLOR
{
    //float3 color = DiffuseColor;
    //color *= tex2D(TextureSampler, input.UV);
    
    //float3 lighting = AmbientColor;
    //float3 lightDirection = normalize(position - input.WorldPosition);
    
    //float3 normal = tex2D(NormalSampler, input.UV).rgb;
    //normal = normal * 2 - 1;
    
    //float3 intensity = saturate(dot(lightDirection, normal)) * lightColor;
    
    //float3 reflection = reflect(lightDirection, normal);
    //lighting += pow(saturate(dot(reflection, input.ViewDirection)), SpecularPower) * SpecularColor;
    
    //float dist = distance(position, input.WorldPosition);
    //float att = 1 - pow(clamp(dist / attenuation, 0, 1), FallOff);
    
    //lighting += intensity;
    
    //Texture color
    float3 color = DiffuseColor;
    color *= tex2D(TextureSampler, input.UV).rgb;
    
    float3 lighting = AmbientColor;
    
    //Normal Texture
    float3 normal = tex2D(NormalSampler, input.UV).rgb;
    normal = normal * 2 - 1;
    normal = float3(0, 0, 0);
    
    //Point Light One
    //float3 intensityOne = saturate(dot(normal, input.LightPosOne)) * LightColor;
    //float3 reflectionOne = reflect(input.LightPosOne, normal);
    //float3 lightingOne = pow(saturate(dot(reflectionOne, input.ViewDirection)), SpecularPower) * SpecularColor;
    //float distanceOne = distance(Position, input.WorldPosition);
    //float attenuationOne = 1 - pow(clamp(distanceOne / Attenuation, 0, 1), FallOff);
    //lightingOne += intensityOne;
    //float4 lightOne = (saturate(lightingOne * attenuationOne), 1);
    
    float4 colorFinal = PointLightCalculation(input, normal, Position, LightColor, Attenuation, color);
    //+PointLightCalculation(input, normal, PositionTwo, LightColorTwo, AttenuationTwo, color);
    return colorFinal;
}

float4 SecondPS(VertexShaderOutput input) :COLOR
{
    //Texture color
    float3 color = DiffuseColor;
    color *= tex2D(TextureSampler, input.UV).rgb;
    
    float3 lighting = AmbientColor;
    
    //Normal Texture
    float3 normal = tex2D(NormalSampler, input.UV).rgb;
    normal = normal * 2 - 1;
    normal = float3(0, 0, 0);
    
    float4 colorFinal = PointLightCalculation(input, normal, PositionTwo, LightColorTwo, AttenuationTwo, color);
    return colorFinal;
}




technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}

    pass P1
    {
        //VertexShader = compile VS_SHADERMODELMainVS();
        PixelShader = compile PS_SHADERMODEL SecondPS();
    }
};

//technique SpriteDrawing
//{
//    pass P0
//    {
//        PixelShader = compile PS_SHADERMODEL MainPS();
//    }
    
//};